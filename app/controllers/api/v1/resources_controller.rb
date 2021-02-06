module Api
  module V1
    class ResourcesController < ApplicationController
      def index
        render json: Resource.all
      end

      def show
        render json: Resource.find(params[:id])
      end

      def create
        resource = Resource.new(resource_params)

        if resource.save
          render json: resource, status: :created
        else
          render json: resource.errors, status: :unprocessable_entity
        end
      end

      def update
        resource = Resource.find(params[:id])

        if resource.update(resource_params)
          render json: resource, status: :ok
        else
          render json: resource.errors, status: :unprocessable_entity
        end
      end
      
      def destroy
        Resource.find(params[:id]).destroy!

        head :no_content
      end

      private

      def resource_params
        params.require(:resource).permit(:name)
      end
    end
  end
end  