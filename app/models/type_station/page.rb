module TypeStation
  class Page
    include ::Mongoid::Document
    include ::Mongoid::Tree
    include ::Mongoid::Tree::Ordering

    TYPES = [:hidden, :draft, :published]

    # RELATIONS

    embeds_many :contents, class_name: 'TypeStation::Content'

    # FIELDS
    field :name, type: Symbol, default: :unnamed
    field :title, type: String, default: 'Untitled'
    field :template_name, type: String, default: 'undefined'

    field :redirect_to, type: String, default: nil
    field :type, type: Symbol, default: TYPES.last # always published unless stated

    field :slug, type: String
    field :path, type: String

    # VALIDATIONS

    validates :slug, uniqueness: true, on: :update
    validates :path, presence: true, uniqueness: true, on: :update

    # Validate that they is only one root page
    validates_each :parent_id do |model, attr, value|
      root_page = TypeStation::Page.root
      model.errors.add(attr, 'already have a root page') if value == nil && root_page.present? && model.id != root_page.id
    end

    # CALLBACKS
    before_create :generate_slug
    before_destroy :destroy_children
    after_rearrange :rebuild_path
    
    # Rebuild self and children paths upon title change
    before_save :generate_slug, if: :title_changed?
    after_save :rebuild_child_paths, if: :has_children?

    # CLASS METHODS

    def self.find_by_path(path)
      self.where(path: File.join('',path)).first
    end

    def self.find_by_name(name)
      self.where(name: name).first
    end

    # INSTANT METHODS

    def update_contents(params)
      params.each do |data|
        field, value, type = data[:field].to_sym, data[:value], data[:type].to_sym

        if page_fields?(field) && !changed.include?(field) #and not changed already
          self[field] = value
        else
          if content?(field)
            set(field, value)
          else
            contents.build(name: field, type: type).set(value)
          end
        end 
      end

      save
    end

    def move_page(direction)
      case direction.to_sym
      when :move_up
        move_up
      when :move_down
        move_down
      end
    end

    def get(key)
      content_attributes[key].get
    end

    def set(key, value)
      content_attributes[key].set value
    end

    def content?(key)
      content_attributes[key].present?
    end

    def page_fields?(key)
      page_fields.include?(key)
    end

    def content_attributes
      @content_attributes ||= Hash[self.contents.map {|c| [c.name, c]}]
    end

    def redirect?
      redirect_to.present?
    end

    def template_name?
      template_name.present? && template_name != 'undefined'
    end

    def visible?(user)
      return true if parent_id == nil # The root page is always visible

      if user.present?
        [:draft, :published].include?(type)
      else
        type == :published
      end
    end

    private

    def page_fields
      @page_fields ||= self.class.fields.keys.map(&:to_sym)
    end

    # Generates a slug based of the title give by the user
    def generate_slug
      self.slug = root? ? "" : title.parameterize
      rebuild_path
    end

    # Rebuild a path based of a ancestors slugs
    def rebuild_path
      self.path = root? ? "/" : self.ancestors_and_self.collect(&:slug).join('/')
    end
    
    def rebuild_child_paths    
      self.children.each do |child|
        child.send :rebuild_path
        child.save
      end
    end

  end
end