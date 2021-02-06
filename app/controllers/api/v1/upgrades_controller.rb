module Api
  module V1
    class UpgradesController < ApplicationController
      def index
        render json: Upgrade.all
      end

      def show
        render json: Upgrade.find(params[:id])
      end

      def create
        upgrade = Upgrade.new(upgrade_params)

        if upgrade.save
          addUpgradeToMines(upgrade)
          render json: upgrade, status: :created
        else
          render json: upgrade.errors, status: :unprocessable_entity
        end
      end

      def update
        upgrade = Upgrade.find(params[:id])

        if upgrade.update(upgrade_params)
          render json: upgrade, status: :ok
        else
          render json: upgrade.errors, status: :unprocessable_entity
        end
      end
      
      def destroy
        Upgrade.find(params[:id]).destroy!

        head :no_content
      end

      private

      def upgrade_params
        params.require(:upgrade).permit(:name, :description, :cost, :value, :type_id)
      end

      def addUpgradeToMines(upgrade)
        mines = Mine.all
        mines.each do |mine|
          mineUpgrade = MineUpgrade.create!(upgrade_id: upgrade.id, mine_id: mine.id)
        end
      end
    end
  end
end