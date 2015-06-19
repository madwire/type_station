module TypeStation
  class PagesController < TypeStation::ApplicationController
    layout 'application'

    def index
      @page = Page.root
      render_type_station
    end

    def show
      @page = Page.find_by_path(params[:path])
      render_type_station
    end

    private

    def render_type_station
      if @page.present? && @page.visible?(type_station_current_user)
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
