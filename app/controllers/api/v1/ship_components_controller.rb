module Api
  module V1
    class ShipComponentsController < ApplicationController
      def index
        render json: ShipComponent.all
      end
    end
  end
end