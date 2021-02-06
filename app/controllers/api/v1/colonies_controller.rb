module Api
  module V1
    class ColoniesController < ApplicationController
      def index
        render json: Colony.all
      end

      def show
        colony = Colony.find(params[:id])
        componentResources = ComponentResource.all

        render json: ColonyRepresenter.new(colony, componentResources).as_json
      end

      def research
        colonyComponent = ColonyComponent.where(colony_id: params[:id]).where(component_id: params[:component_id]).take
        user = User.find(colonyComponent.colony.user.id)
        
        if 0 <= user.balance - colonyComponent.component.research_cost
          balance = user.balance - colonyComponent.component.research_cost
          if user.update(balance: balance)
            if colonyComponent.update(researched: true)
              render json: colonyComponent, status: :ok
            else
              render json: colonyComponent.errors, status: :unprocessable_entity
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
        colonyComponent = ColonyComponent.where(colony_id: params[:id]).where(component_id: params[:component_id]).take
        user = User.find(colonyComponent.colony.user.id)
        componentResources = ComponentResource.all
        
        
        if 0 <= user.balance - colonyComponent.component.build_cost && colonyComponent.researched && resourcesAvailable(user, colonyComponent, componentResources)
          balance = user.balance - colonyComponent.component.build_cost
          if user.update(balance: balance)
            useResources(user, colonyComponent, componentResources)

            inventoryComponent = InventoryComponent.where(inventory_id: user.inventory_id).where(component_id: colonyComponent.component_id).take
            amount = inventoryComponent.amount + 1
            inventoryComponent.update(amount: amount)
            render json: inventoryComponent
          else
            render json: user.errors, status: :unprocessable_entity
          end
        elsif !colonyComponent.researched
          render json: {"error": "not researched"}
          return
        elsif !(0 <= user.balance - colonyComponent.component.build_cost)
          render json: {"error": "not enough credits"}
          return
        else
          render json: {"error": "not enough resources"}
          return
        end
      end

      private

      def resourcesAvailable(user, colonyComponent, componentResources)
        var = true

        for @componentResource in componentResources do
          if @componentResource.component_id == colonyComponent.component.id
            for inventoryResource in user.inventory.inventoryResources do
              if inventoryResource.resource_id == @componentResource.resource_id && inventoryResource.amount < @componentResource.amount
                var = false
                return var
              end
            end
          end
        end
        return var
      end

      def useResources(user, colonyComponent, componentResources)
        for @componentResource in componentResources do
          if @componentResource.component_id == colonyComponent.component.id
            for inventoryResource in user.inventory.inventoryResources do
              if inventoryResource.resource_id == @componentResource.resource_id
                
                amount = inventoryResource.amount - @componentResource.amount
                inventoryResource.update(amount: amount)
                
              end
            end
          end
        end
      end

    end
  end
end
