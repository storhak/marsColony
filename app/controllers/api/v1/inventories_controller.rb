module Api
  module V1
    class InventoriesController < ApplicationController
      def index
        inventories = Inventory.all

        render json: InventoriesRepresenter.new(inventories).as_json
      end
    end
  end
end  