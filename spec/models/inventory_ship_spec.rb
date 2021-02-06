require 'rails_helper'

describe "InventoryShip Model", inventoryShip: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
  end
  
  
  describe 'delete' do
    before do
      @ship = FactoryBot.create(:ship, name: "shuttle")
      @inventoryShip = FactoryBot.create(:inventory_ship, inventory_id:  @inventory.id, ship_id: @ship.id)
    end
    

    it 'delete Inventoryship' do
      expect(Inventory.count).to eq(1)
      expect(Ship.count).to eq(1)
      expect(InventoryShip.count).to eq(1)

      @inventoryShip.destroy

      expect(InventoryShip.count).to eq(0)
      expect(Inventory.count).to eq(1)
      expect(Ship.count).to eq(1)
    end

    it 'delete inventory with Inventoryship' do
      expect(Inventory.count).to eq(1)
      expect(Ship.count).to eq(1)
      expect(InventoryShip.count).to eq(1)

      @inventory.destroy
      
      expect(InventoryShip.count).to eq(0)
      expect(Inventory.count).to eq(0)
      expect(Ship.count).to eq(1)
    end

    it 'delete Ship with Inventoryship' do
      expect(Inventory.count).to eq(1)
      expect(Ship.count).to eq(1)
      expect(InventoryShip.count).to eq(1)

      @ship.destroy
      
      expect(InventoryShip.count).to eq(0)
      expect(Inventory.count).to eq(1)
      expect(Ship.count).to eq(0)
    end
  end
end