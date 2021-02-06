require 'rails_helper'

describe "ComponentResource Model", componentResource: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
  end
  
  
  describe 'delete' do
    before do
      @resource = FactoryBot.create(:resource, name: "iron")
      @component = FactoryBot.create(:component, name: "test comp", description: "test desc")
      @componentResource = FactoryBot.create(:component_resource, resource_id:  @resource.id, component_id: @component.id)
    end
    

    it 'delete componentResource' do
      expect(Resource.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ComponentResource.count).to eq(1)

      @componentResource.destroy

      expect(ComponentResource.count).to eq(0)
      expect(Resource.count).to eq(1)
      expect(Component.count).to eq(1)
    end

    it 'delete resource with componentResource' do
      expect(Resource.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ComponentResource.count).to eq(1)

      @resource.destroy
      
      expect(ComponentResource.count).to eq(0)
      expect(Resource.count).to eq(0)
      expect(Component.count).to eq(1)
    end

    it 'delete component with componentResource' do
      expect(Resource.count).to eq(1)
      expect(Component.count).to eq(1)
      expect(ComponentResource.count).to eq(1)

      @component.destroy
      
      expect(ComponentResource.count).to eq(0)
      expect(Resource.count).to eq(1)
      expect(Component.count).to eq(0)
    end
  end
end
