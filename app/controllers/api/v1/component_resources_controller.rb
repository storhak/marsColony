module Api
  module V1
    class ComponentResourcesController < ApplicationController
      def index
        render json: ComponentResource.all
      end
    end
  end
end