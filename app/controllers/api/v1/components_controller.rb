module Api
  module V1
    class ComponentsController < ApplicationController
      def index
        render json: Component.all
      end
    end
  end
end
