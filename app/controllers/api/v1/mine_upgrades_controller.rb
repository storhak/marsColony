module Api
  module V1
    class MineUpgradesController < ApplicationController
      def index
          render json: MineUpgrade.all
      end
    end
  end
end