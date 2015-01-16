module TypeStation
  class ContentPresenter < BasePresenter
    presents :content

    def value
      content.get
    end

    def call(&block)
      case content.type
      when :image, :file
        block.call(OpenStruct.new(content.get))
      when :multiple_select
        block.call(content.get)
      when :html
        content.get.html_safe
      else
        content.get
      end.to_s
    end

    private

    def image_struct
      OpenStruct.new({url: content.get, alt: ''})
    end

    def image_struct
      OpenStruct.new({url: '', alt: ''})
    end

    def select_struct
      OpenStruct.new({value: content.get, values: content.get })
    end

  end
end