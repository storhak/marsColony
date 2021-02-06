module Api
  module V1
    class InventoryResourcesController < ApplicationController
      def mined
        params.permit(:amount)
        inventoryResource = InventoryResource.find(params[:id])
        mine = Mine.where(inventory_id: inventoryResource.inventory_id).take
        amount = params[:amount]
        amount = calcMultiplier(mine) * amount.to_i

        
        
        
        uranium = Resource.where(name: "uranium").take
        userUranium = InventoryResource.where(inventory_id: mine.user.inventory.id).where(resource_id: uranium.id).take
        
        if userUranium.amount > 0
          charges = (amount - mine.energy) / calcEnergyCap(mine) + 1
          while charges > 0
            if 0 <= userUranium.amount - calcUraniumCost(mine)
              userUranium.amount -= calcUraniumCost(mine)
              mine.energy += calcEnergyCap(mine)
              charges -= 1
            else
              charges -= 1
            end
          end
        end

        
        energy = mine.energy - amount
        if energy < 0
          amount = (amount + energy/2) + inventoryResource.amount
          mine.energy = 0
        else
          amount = amount + inventoryResource.amount
          mine.energy = energy
        end


        if inventoryResource.update_attribute(:amount, amount) 
          mine.update_attribute(:energy, mine.energy) 
          userUranium.update_attribute(:amount, userUranium.amount)
          render json: inventoryResource, status: :ok
        else
          render json: inventoryResource.errors, status: :unprocessable_entity
        end
      end

      def transfer
        params.permit(:amount, :inventory_id, :resource_id)
        inventoryResource = InventoryResource.find(params[:id])
        if inventoryResource.inventory_id==params[:inventory_id].to_i
          render json: {"error": "cant trasfer to the same inventory"}
          return
        end
        
        inventoryReceiver = receiver(params)

        amount = params[:amount]
        if 0 <= inventoryResource.amount - amount.to_i && amount.to_i > 0
          amount = inventoryResource.amount - amount.to_i
        else
          render json: {"error": "not enough resources"}
          return
        end

        if inventoryResource.update_attribute(:amount, amount)
          amount = params[:amount]
          amount = inventoryReceiver.amount + amount.to_i
          if inventoryReceiver.update_attribute(:amount, amount)
            render json: inventoryReceiver, status: :ok
          else
            render json: inventoryReceiver.errors, status: :unprocessable_entity
          end
        else
          render json: inventoryResource.errors, status: :unprocessable_entity
        end
      end

      private

      def receiver(params)
        if InventoryResource.where(inventory_id: params[:inventory_id]).where(resource_id: params[:resource_id]).take.present?
          return inventoryReceiver = InventoryResource.where(inventory_id: params[:inventory_id]).where(resource_id: params[:resource_id]).take
        else
          return inventoryReceiver = InventoryResource.create!(amount: 0, inventory_id: params[:inventory_id], resource_id: params[:resource_id])
        end
      end

      def calcMultiplier(mine)
        val = mine.multiplier
        mine.mineUpgrades.each do |mineUpgrade|
          if mineUpgrade.bought == true && mineUpgrade.upgrade.type.name == "multiplier"
            val *= mineUpgrade.upgrade.value
          end
        end
        return val
      end

      def calcEnergyCap(mine)
        val = mine.energyCap
        mine.mineUpgrades.each do |mineUpgrade|
          if mineUpgrade.bought == true && mineUpgrade.upgrade.type.name == "energyCap"
            val *= mineUpgrade.upgrade.value
          end
        end
        return val
      end

      def calcUraniumCost(mine)
        val = mine.uraniumCost
        mine.mineUpgrades.each do |mineUpgrade|
          if mineUpgrade.bought == true && mineUpgrade.upgrade.type.name == "uraniumCost"
            val -= mineUpgrade.upgrade.value
          end
        end
        return val
      end
    end
  end
end  