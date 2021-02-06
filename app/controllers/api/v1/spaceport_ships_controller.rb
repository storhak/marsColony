module Api
  module V1
    class SpaceportShipsController < ApplicationController
        def index
          render json: SpaceportShip.all
        end
      end
    end
  end