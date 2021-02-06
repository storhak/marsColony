module Api
  module V1
    class InventoryComponentsController < ApplicationController
      def index
        render json: InventoryComponent.all
      end
    end
  end
end