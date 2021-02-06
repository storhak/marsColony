module Api
  module V1
    class MinesController < ApplicationController
      def index
        mines = Mine.all

        render json: MinesRepresenter.new(mines).as_json
      end

      def show
        mine = Mine.find(params[:id])

        render json: MineRepresenter.new(mine).as_json
      end

      def create
        begin
          inventory = Inventory.create!()
          mine = Mine.new(mine_params.merge(inventory_id: inventory.id)) 
        rescue => exception
          inventory.destroy!
        end

        if mine.save
          inventoryResource = InventoryResource.create!(inventory_id: inventory.id, resource_id: mine.resource_id)
          addUpgradesToMine(mine)
          render json: MineRepresenter.new(mine).as_json, status: :created
        else
          inventory.destroy!
          render json: mine.errors, status: :unprocessable_entity
        end
      end

      def update
        mine = Mine.find(params[:id])

        if mine.update(mine_params)
          render json: MineRepresenter.new(mine).as_json, status: :ok
        else
          render json: mine.errors, status: :unprocessable_entity
        end
      end
    
      def destroy
        Mine.find(params[:id]).destroy!

        head :no_content
      end

      def buy
        mineUpgrade = MineUpgrade.where(mine_id: params[:id]).where(upgrade_id: params[:upgrade_id]).take
        user = User.find(mineUpgrade.mine.user.id)
        
        if 0 <= user.balance - mineUpgrade.upgrade.cost
          balance = user.balance - mineUpgrade.upgrade.cost
          if user.update(balance: balance)
            if mineUpgrade.update(bought: true)
              render json: mineUpgrade, status: :ok
            else
              render json: mineUpgrade.errors, status: :unprocessable_entity
            end
          else
            render json: user.errors, status: :unprocessable_entity
          end
        else
          render json: {"error": "not enough credits"}
          return
        end
      end
      

      private

      def mine_params
        params.require(:mine).permit(:name, :uraniumCost, :energy, :energyCap, :multiplier, :user_id, :resource_id)
      end

      def addUpgradesToMine(mine)
        upgrades = Upgrade.all
        upgrades.each do |upgrade|
          mineUpgrade = MineUpgrade.create!(upgrade_id: upgrade.id, mine_id: mine.id)
        end
      end
    end
  end
end 