module Api
  module V1
    class ShipsController < ApplicationController
      def index
        render json: Ship.all
      end
    end
  end
end