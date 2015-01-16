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

    # VALIDATIONS

    validates :name, presence: true
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
      #when :image
      #  preloaded = Cloudinary::PreloadedFile.new(value)         
      #  raise "Invalid upload signature" if !preloaded.valid?
      #  preloaded.identifier
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
  end
end