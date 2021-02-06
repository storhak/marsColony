require 'rails_helper'

describe "ShipComponent Model", shipComponent: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
  end
  
  
  describe 'delete' do
    before do
      @ship = FactoryBot.create(:ship, name: "shuttle")
      @component = FactoryBot.create(:component, name: "test comp", description: "test desc")
      @shipComponent = FactoryBot.create(:ship_component, ship_id:  @ship.id, component_id: @component.id)
    end
    

    it 'delete shipComponent' do
      expect(Ship.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ShipComponent.count).to eq(1)

      @shipComponent.destroy

      expect(ShipComponent.count).to eq(0)
      expect(Ship.count).to eq(1)
      expect(Component.count).to eq(1)
    end

    it 'delete ship with shipComponent' do
      expect(Ship.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ShipComponent.count).to eq(1)

      @ship.destroy
      
      expect(ShipComponent.count).to eq(0)
      expect(Ship.count).to eq(0)
      expect(Component.count).to eq(1)
    end

    it 'delete component with shipComponent' do
      expect(Ship.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ShipComponent.count).to eq(1)

      @component.destroy
      
      expect(ShipComponent.count).to eq(0)
      expect(Ship.count).to eq(1)
      expect(Component.count).to eq(0)
    end
  end
end