module TypeStation
  class BasePresenter

    def initialize(object, template, options = {})
      @object = object
      @template = template
      @options = options
    end

    private

    def self.presents(name)
      define_method(name) do
        @object
      end
    end

    def h
      @template
    end

    def markdown(text)
      Redcarpet.new(text, :hard_wrap, :filter_html, :autolink).to_html.html_safe
    end

    def method_missing(*args, &block)
      @template.send(*args, &block)
    end

  end
end
