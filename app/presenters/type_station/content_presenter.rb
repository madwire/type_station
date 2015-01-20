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

  end
end