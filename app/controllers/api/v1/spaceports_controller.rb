module Api
  module V1
    class SpaceportsController < ApplicationController
      def index
        render json: Spaceport.all
      end

      def show
        spaceport = Spaceport.find(params[:id])

        render json: SpaceportRepresenter.new(spaceport).as_json
      end

      def research
        spaceportShip = SpaceportShip.where(spaceport_id: params[:id]).where(ship_id: params[:ship_id]).take
        user = User.find(spaceportShip.spaceport.user.id)
        
        if 0 <= user.balance - spaceportShip.ship.research_cost
          balance = user.balance - spaceportShip.ship.research_cost
          if user.update(balance: balance)
            if spaceportShip.update(researched: true)
              render json: spaceportShip, status: :ok
            else
              render json: spaceportShip.errors, status: :unprocessable_entity
            end
          else
            render json: user.errors, status: :unprocessable_entity
          end
        else
          render json: {"error": "not enough credits"}
          return
        end
      end

      def produce
        spaceportShip = SpaceportShip.where(spaceport_id: params[:id]).where(ship_id: params[:ship_id]).take
        user = User.find(spaceportShip.spaceport.user.id)
        shipComponents = ShipComponent.all
        
        
        if 0 <= user.balance - spaceportShip.ship.build_cost && spaceportShip.researched && componentsAvailable(user, spaceportShip, shipComponents)
          balance = user.balance - spaceportShip.ship.build_cost
          if user.update(balance: balance)
            useComponents(user, spaceportShip, shipComponents)

            inventoryShip = InventoryShip.where(inventory_id: user.inventory_id).where(ship_id: spaceportShip.ship_id).take
            amount = inventoryShip.amount + 1
            inventoryShip.update(amount: amount)
            render json: inventoryShip
          else
            render json: user.errors, status: :unprocessable_entity
          end
        elsif !spaceportShip.researched
          render json: {"error": "not researched"}
          return
        elsif !(0 <= user.balance - spaceportShip.ship.build_cost)
          render json: {"error": "not enough credits"}
          return
        else
          render json: {"error": "not enough components"}
          return
        end
      end

      private

      def componentsAvailable(user, spaceportShip, shipComponents)
        var = true

        for @shipComponent in shipComponents do
          if @shipComponent.ship_id == spaceportShip.ship.id
            for inventoryComponent in user.inventory.inventoryComponents do
              if inventoryComponent.component_id == @shipComponent.component_id && inventoryComponent.amount < @shipComponent.amount
                var = false
                return var
              end
            end
          end
        end
        return var
      end

      def useComponents(user, spaceportShip, shipComponents)
        for @shipComponent in shipComponents do
          if @shipComponent.ship_id == spaceportShip.ship.id
            for inventoryComponent in user.inventory.inventoryComponents do
              if inventoryComponent.component_id == @shipComponent.component_id
                
                amount = inventoryComponent.amount - @shipComponent.amount
                inventoryComponent.update(amount: amount)
                
              end
            end
          end
        end
      end
      
    end
  end
end
