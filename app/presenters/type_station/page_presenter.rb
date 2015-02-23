module TypeStation
  class PagePresenter < BasePresenter
    presents :page
    delegate :to_param, :title, :path, :slug, :type, :template_name, :template_name?, :visible?, :redirect_to, :redirect?, :position, to: :page

    def initialize(object, template)
      super(object, template)
      build_content_methods
    end

    def edit_url
      h.type_station.admin_page_url(page)
    end

    def new_url
      h.type_station.admin_pages_url
    end

    def children(options = {})
      children_criteria = page.children

      options.each do |method, value|
        children_criteria = children_criteria.send method, value
      end

      @children ||= children_criteria.map {|p| PagePresenter.new(p, @template)}
    end

    def parent
      @parent ||= PagePresenter.new(page.parent, @template)
    end

    def root
      @root ||= PagePresenter.new(TypeStation::Page.root, @template)
    end

    private

    def build_content_methods
      page.content_attributes.each do |key, content_object|
        define_singleton_method key do
          ContentPresenter.new(content_object, @template)
        end
      end
    end
    
  end
end