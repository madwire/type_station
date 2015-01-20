module TypeStation
  class PagePresenter < BasePresenter
    presents :page
    delegate :to_param, :path, :slug, :template_name, :template_name?, :redirect_to, :redirect?, to: :page

    def initialize(object, template)
      super(object, template)
      build_content_methods
    end

    def edit_url
      h.type_station.admin_page_url(page)
    end

    def title
      ContentPresenter.new(OpenStruct.new({type: :text, get: page.title}), @template)
    end

    def children
      @children ||= page.children.map {|p| PagePresenter.new(p, @template)}
    end

    def parent
      @parent ||= PagePresenter.new(page.parent, @template)
    end

    private

    def build_content_methods
      page.content_attributes.each do |key, content_object|
        self.class.send :define_method, key do
          ContentPresenter.new(content_object, @template)
        end
      end
    end
    
  end
end