module TypeStation
  module Admin
    class PagesController < ::TypeStation::AdminController
      
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
        [params[:contents]].flatten
      end

    end
  end
end