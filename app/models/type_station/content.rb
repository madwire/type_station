module TypeStation
  class Content
    include ::Mongoid::Document
    include ::Mongoid::Attributes::Dynamic

    TYPES = [:text, :html, :image, :file, :select, :multiple_select]

    # RELATIONS

    embedded_in :page

    # FIELDS
    field :name, type: Symbol
    field :type, type: Symbol, default: TYPES.first

    after_save :clean_up

    # VALIDATIONS

    validates :name, presence: true, uniqueness: { scope: :type }
    validates :type, presence: true

    # INSTANT METHODS

    def get
      self[self.type]
    end

    def set(value)
      self[self.type] = convert(value)
    end

    private

    def convert(value)
      case type
      when :multiple_select
        convert_to_array(value)
      else
        value
      end
    end

    def convert_to_array(value)
      if value.is_a?(String)
        value.split(',').map(&:strip)
      elsif value.is_a?(Array)
        value
      else
        raise 'Dont know who to covert value to array'
      end
    end

    def clean_up
      case type
      when :image, :file
        original = changes[type.to_s][0]
        if original && original['identifier']
          Cloudinary::Uploader.destroy(original['identifier'])
        end
      end
    end

  end
end
