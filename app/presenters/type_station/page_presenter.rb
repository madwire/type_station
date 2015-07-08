module TypeStation
  class PagePresenter < Presenter
    presents :page
    delegate :to_param, :title, :path, :slug, :type, :template_name, :template_name?, :visible?, :redirect_to, :redirect?, :position, to: :page

    form_field :title, type: :text, label: 'Title', required: true

    def children
      TypeStation::Page.where(parent_id: page.id)
    end

    def parent
      page.root
    end

  end
end
