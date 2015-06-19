module TypeStation
  module Admin
    class PagesController < ::TypeStation::AdminController

    def index
      @pages = TypeStation::Page.in(status: [:draft, :published])
      @pages = @pages.where(title: /#{params[:title]}/i) if params[:title]
      @pages = @pages.where(path: /#{params[:path]}/i) if params[:path]

      render json: { status: :success, pages: @pages }, status: :ok
    end

  end

end
