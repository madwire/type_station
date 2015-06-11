module TypeStation
  class Entity
    include ::Mongoid::Document
    include ::Mongoid::Tree
    include ::Mongoid::Tree::Ordering

    # RELATIONS
    embeds_many :contents, class_name: 'TypeStation::Content'

    # FIELDS
    field :name, type: Symbol, default: :unnamed

    # CLASS METHODS

    def self.find_by_name(name)
      self.where(name: name).first
    end

    # INSTANT METHODS

    def update_contents(params)
      params.each do |data|
        field, value, type = data[:field].to_sym, data[:value], data[:type].to_sym

        if entity_fields?(field) && !changed.include?(field) #and not changed already
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

    def content_attributes
      @content_attributes ||= Hash[self.contents.map {|c| [c.name, c]}]
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

    def entity_fields?(key)
      entity_fields.include?(key)
    end

    def move_entity(direction)
      case direction.to_sym
      when :move_up
        move_up
      when :move_down
        move_down
      end
    end

    private

    def entity_fields
      @entity_fields ||= self.class.fields.keys.map(&:to_sym)
    end

  end
end