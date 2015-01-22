module TypeStation
  module Admin
    class PagesController < ::TypeStation::AdminController

      def create
        @page = TypeStation::Page.new(title: params[:title])

        if params[:parent_id]
          parent_page = TypeStation::Page.find(params[:parent_id]) 
          @page.parent = parent_page
        end

        if @page.save
          render json: { status: :success, url: @page.path }, status: :ok
        else
          render json: @page.errors, status: :unprocessable_entity
        end
      end
      
      def update
        @page = TypeStation::Page.find(params[:id])

        if @page.update_contents(contents)
          render json: { status: :success }, status: :ok
        else
          render json: @page.errors, status: :unprocessable_entity
        end
      end

      private

      def contents
        [params[:contents]].compact.flatten
      end

    end
  end
end