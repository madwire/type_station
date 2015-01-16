module TypeStation
  class PagesController < TypeStation::ApplicationController
    layout 'application'
    
    def index
      @page = present Page.root
      render_type_station
    end

    def show
      @page = present Page.find_by_path(params[:path])
      render_type_station
    end

    private

    def render_type_station
      if @page.present?
        if @page.redirect?
          redirect_to @page.redirect_to
        else
          if @page.template_name? 
            render "pages/#{@page.template_name}"
          else
            raise TypeStation::PageTemplateNameUndefined
          end
        end
      else
        raise TypeStation::PageNotFoundError
      end
    end

  end
end