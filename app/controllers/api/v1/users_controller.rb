module Api
  module V1
    class UsersController < ApplicationController
      before_action :authorized, only: [:auto_login, :index, :show, :showMines, :update, :destroy]

      def index
        render json: User.all
      end

      def show
        user = User.find(params[:id])

        render json: UserRepresenter.new(user).as_json
      end

      def topTen
        users = User.all.order('balance DESC').limit(10)

        render json: UsersRepresenter.new(users).as_json
      end

      def login
        @user = User.find_by(name: params[:username])

        if @user && @user.authenticate(params[:password])
          token = encode_token({user_id: @user.id})
          render json: {user: @user, token: token}
        else
          render json: {error: "Invalid username or password"}, status: :unprocessable_entity
        end
      end

      def auto_login
        render json: @user
      end

      def showMines
        user = User.find(params[:id])

        render json: UserRepresenter.new(user).mines_as_json
      end

      def create
        begin
          @inventory = Inventory.create!()
          @user = User.new(user_params.merge(inventory_id: @inventory.id))
          resources = Resource.all
          resources.each do |resource|
            inventoryResource = InventoryResource.create!(inventory_id: @inventory.id, resource_id: resource.id)
          end
        rescue => exception
          @inventory.destroy!
        end
        
        if @user.valid?
          @user.save
          addMine()
          addColony()
          addSpaceport()

          token = encode_token({user_id: @user.id})
          render json: {user: @user, token: token}, status: :created
          #render json: UserRepresenter.new(user).as_json, status: :created
        else
          @inventory.destroy!
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        user = User.find(params[:id])

        if user.update(user_params)
          render json: UserRepresenter.new(user).as_json, status: :ok
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end
      
      def destroy
        User.find(params[:id]).destroy!

        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:name, :password ,:balance)
      end

      def addMine()
        begin
          inventory = Inventory.create!()
          mine = Mine.create!(name: "starter mine", resource_id: 1, user_id: @user.id, inventory_id: inventory.id)
          inventoryResource = InventoryResource.create!(inventory_id: inventory.id, resource_id: mine.resource_id)
          
          upgrades = Upgrade.all
          upgrades.each do |upgrade|
            mineUpgrade = MineUpgrade.create!(upgrade_id: upgrade.id, mine_id: mine.id)
          end
        rescue => exception
          inventory.destroy!
        end
      end
      
      def addColony()
        colony = Colony.create!(user_id: @user.id)

        components = Component.all
        components.each do |component|
          colonyComponent = ColonyComponent.create!(component_id: component.id, colony_id: colony.id)
          inventoryComponent = InventoryComponent.create!(component_id: component.id, inventory_id: @inventory.id)
        end
      end
      
      def addSpaceport()
        spaceport = Spaceport.create!(user_id: @user.id)
        
        ships = Ship.all
        ships.each do |ship|
          spaceportShip = SpaceportShip.create!(ship_id: ship.id, spaceport_id: spaceport.id)
          inventoryShip = InventoryShip.create!(ship_id: ship.id, inventory_id: @inventory.id)
        end
      end
    end
  end
end