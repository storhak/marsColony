module Api
  module V1
    class InventoryShipsController < ApplicationController
      def index
        render json: InventoryShip.all
      end
    end
  end
end