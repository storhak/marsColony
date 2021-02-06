module Api
  module V1
    class ColonyComponentsController < ApplicationController
      def index
        render json: ColonyComponent.all
      end
    end
  end
end