require 'rails_helper'

describe "ColonyComponent Model", colonyComponent: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
  end
  
  
  describe 'delete' do
    before do
      @colony = FactoryBot.create(:colony, user_id: @user.id)
      @component = FactoryBot.create(:component, name: "test comp", description: "test desc")
      @colonyComponent = FactoryBot.create(:colony_component, colony_id:  @colony.id, component_id: @component.id)
    end
    

    it 'delete colonyComponent' do
      expect(Colony.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ColonyComponent.count).to eq(1)

      @colonyComponent.destroy

      expect(ColonyComponent.count).to eq(0)
      expect(Colony.count).to eq(1)
      expect(Component.count).to eq(1)
    end

    it 'delete colony with colonyComponent' do
      expect(Colony.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ColonyComponent.count).to eq(1)

      @colony.destroy
      
      expect(ColonyComponent.count).to eq(0)
      expect(Colony.count).to eq(0)
      expect(Component.count).to eq(1)
    end

    it 'delete component with colonyComponent' do
      expect(Colony.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ColonyComponent.count).to eq(1)

      @component.destroy
      
      expect(ColonyComponent.count).to eq(0)
      expect(Colony.count).to eq(1)
      expect(Component.count).to eq(0)
    end
  end
end
