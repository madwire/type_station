module TypeStation
  class Entity
    include ::Mongoid::Document
    include ::Mongoid::Tree
    include ::Mongoid::Tree::Ordering

    # RELATIONS
    embeds_many :contents, class_name: 'TypeStation::Content', cascade_callbacks: true

    # FIELDS
    field :name, type: Symbol, default: :unnamed

    # CLASS METHODS

    def self.find_by_name(name)
      self.where(name: name).first
    end

    # INSTANT METHODS

    def update_contents(params)
      params.each do |data|
        d = data.to_unsafe_h
        field, value, type = d[:field].to_sym, d[:value], d[:type].to_sym
        set(field, value, type)
      end

      save
    end

    def content_attributes
      @content_attributes ||= Hash[self.contents.map {|c| [c.name, c]}]
    end

    def get(key)
      if entity_fields?(key)
        self[key]
      elsif content?(key)
        content_attributes[key].get
      else
        nil
      end
    end

    def set(key, value, type = 'text')
      if entity_fields?(key) && !changed.include?(key) #and not changed already
        self[key] = value
      else
        if content?(key)
          content_attributes[key].set value
        else
          contents.build(name: key, type: type).set(value)
        end
      end
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
