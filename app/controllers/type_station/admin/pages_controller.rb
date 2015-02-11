module TypeStation
  module Admin
    class PagesController < ::TypeStation::AdminController

      def index
        @pages = TypeStation::Page.in(type: [:draft, :published])
        @pages = @pages.where(title: /#{params[:title]}/i) if params[:title]
        @pages = @pages.where(path: /#{params[:path]}/i) if params[:path]

        render json: { status: :success, pages: @pages }, status: :ok
      end

      def create
        @page = TypeStation::Page.new(title: params[:title])

        if params[:parent_id]
          parent_page = TypeStation::Page.find(params[:parent_id]) 
          @page.parent = parent_page
        end

        if @page.update_contents(contents)
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

      def move
        response = {success: false, message: ''}
        page = TypeStation::Page.find(params[:id])

        if page && params[:direction] && ['up', 'down'].include?(params[:direction])
          if page.method("move_#{params[:direction]}").call
            response[:success] = true
            response[:message] = params[:direction]
          else
            response[:message] = 'Failed to move page'
          end
        else
          resposne[:message] = 'Invalid parameters'
        end
        respond_to do |format|
          format.html { render text: response.inspect }
          format.json { render json: response }
        end
      end

      private

      def contents
        [params[:contents]].compact.flatten
      end

    end
  end
end