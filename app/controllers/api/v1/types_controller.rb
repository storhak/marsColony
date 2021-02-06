module Api
  module V1
    class TypesController < ApplicationController
      def index
        render json: Type.all
      end
    end
  end
end
