module TypeStation
  module Admin
    class EntitiesController < ::TypeStation::AdminController

      def create
        @entity = Mongoid::Factory.build TypeStation::Entity, '_type' => params[:_type].classify

        if params[:parent_id]
          parent_entity = TypeStation::Entity.find(params[:parent_id])
          @entity.parent = parent_entity
        end

        if @entity.update_contents(contents)
          render json: { status: :success, entity: @entity }, status: :ok
        else
          render json: @entity.errors, status: :unprocessable_entity
        end
      end

      def update
        @entity = TypeStation::Entity.find(params[:id])

        if params[:direction]
          @entity.move_entity params[:direction]
        end

        if @entity.update_contents(contents)
          render json: { status: :success }, status: :ok
        else
          render json: @entity.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @entity = TypeStation::Entity.find(params[:id])

        if @entity.delete
          render json: { status: :success }, status: :ok
        else
          render json: @entity.errors, status: :unprocessable_entity
        end
      end


      private

      def contents
        [params[:contents]].compact.flatten
      end

    end
  end
end
