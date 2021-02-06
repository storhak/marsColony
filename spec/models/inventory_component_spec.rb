require 'rails_helper'

describe "InventoryComponent Model", inventoryComponent: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
  end
  
  
  describe 'delete' do
    before do
      @component = FactoryBot.create(:component, name: "test comp", description: "test desc")
      @inventoryComponent = FactoryBot.create(:inventory_component, inventory_id:  @inventory.id, component_id: @component.id)
    end
    

    it 'delete inventoryComponent' do
      expect(Inventory.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(InventoryComponent.count).to eq(1)

      @inventoryComponent.destroy

      expect(InventoryComponent.count).to eq(0)
      expect(Inventory.count).to eq(1)
      expect(Component.count).to eq(1)
    end

    it 'delete inventory with inventoryComponent' do
      expect(Inventory.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(InventoryComponent.count).to eq(1)

      @inventory.destroy
      
      expect(InventoryComponent.count).to eq(0)
      expect(Inventory.count).to eq(0)
      expect(Component.count).to eq(1)
    end

    it 'delete component with inventoryComponent' do
      expect(Inventory.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(InventoryComponent.count).to eq(1)

      @component.destroy
      
      expect(InventoryComponent.count).to eq(0)
      expect(Inventory.count).to eq(1)
      expect(Component.count).to eq(0)
    end
  end
end