require 'rails_helper'

describe "Colonies API", colony: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }


    @colony = FactoryBot.create(:colony, user_id: @user.id)
    @spaceport = FactoryBot.create(:spaceport, user_id: @user.id)
  end
  
  describe 'GET /Colonies' do
    it 'returns all Colonies' do
      get '/api/v1/colonies', headers: @headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)  
    end

    it 'returns 1 colony' do
      get "/api/v1/colonies/#{@colony.id}", headers: @headers

      expect(response).to have_http_status(:success)
    end
  end

  describe 'research component' do
    before do
      @component = FactoryBot.create(:component, name: "test comp", description: "test desc")
      @component2 = FactoryBot.create(:component, name: "test comp", description: "test desc", research_cost: 5000)
      @colonyComponent = FactoryBot.create(:colony_component, colony_id: @colony.id, component_id: @component.id)
      @colonyComponent2 = FactoryBot.create(:colony_component, colony_id: @colony.id, component_id: @component2.id)
    end
    

    it "research component" do
      put "/api/v1/colonies/#{@colony.id}/research", params: { component_id: @component.id }, headers: @headers
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("researched" => true)
    end

    it "research component + not enough credit" do
      put "/api/v1/colonies/#{@colony.id}/research", params: { component_id: @component2.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not enough credits")
    end
  end

  describe 'produce component' do
    before do
      @resource = FactoryBot.create(:resource, name: "iron")
      @resource2 = FactoryBot.create(:resource, name: "tin")
      @inventoryResource = FactoryBot.create(:inventory_resource, amount: 100, inventory_id: @user.inventory_id, resource_id: @resource.id)
      @inventoryResource2 = FactoryBot.create(:inventory_resource, amount: 80, inventory_id: @user.inventory_id, resource_id: @resource2.id)
      @component = FactoryBot.create(:component, name: "comp1", description: "test desc", build_cost: 1000)
      @component2 = FactoryBot.create(:component, name: "comp2", description: "test desc")
      @component3 = FactoryBot.create(:component, name: "comp3", description: "test desc", build_cost: 500000)
      @component4 = FactoryBot.create(:component, name: "comp4", description: "test desc")
      @colonyComponent = FactoryBot.create(:colony_component, colony_id: @colony.id, component_id: @component.id, researched: true)
      @colonyComponent2 = FactoryBot.create(:colony_component, colony_id: @colony.id, component_id: @component2.id)
      @colonyComponent3 = FactoryBot.create(:colony_component, colony_id: @colony.id, component_id: @component3.id, researched: true)
      @colonyComponent4 = FactoryBot.create(:colony_component, colony_id: @colony.id, component_id: @component4.id, researched: true)
      @inventoryComponent = FactoryBot.create(:inventory_component, inventory_id:  @inventory.id, component_id: @component.id)
      @inventoryComponent2 = FactoryBot.create(:inventory_component, inventory_id:  @inventory.id, component_id: @component4.id)
      @componentResource = FactoryBot.create(:component_resource, resource_id:  @resource.id, component_id: @component.id, amount: 50)
      @componentResource2 = FactoryBot.create(:component_resource, resource_id:  @resource2.id, component_id: @component.id, amount: 50)
      @component2Resource = FactoryBot.create(:component_resource, resource_id:  @resource.id, component_id: @component4.id, amount: 100)
      @component2Resource2 = FactoryBot.create(:component_resource, resource_id:  @resource2.id, component_id: @component4.id, amount: 800)
    end
    

    it "produce component" do
      put "/api/v1/colonies/#{@colony.id}/produce", params: { component_id: @component.id }, headers: @headers
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 1)
      
      get "/api/v1/users/#{@user.id}", headers: @headers
      expect(JSON.parse(response.body).fetch("user")).to include("balance" => 3000)
      expect(JSON.parse(response.body).fetch("user").fetch("inventory").fetch("resources").fetch(0)).to include("name" => "iron", "amount" => 50)
      expect(JSON.parse(response.body).fetch("user").fetch("inventory").fetch("resources").fetch(1)).to include("name" => "tin", "amount" => 30)
      expect(JSON.parse(response.body).fetch("user").fetch("inventory").fetch("components").fetch(0)).to include("name" => "comp1", "amount" => 1)
    end

    it "produce component + not researched" do
      put "/api/v1/colonies/#{@colony.id}/produce", params: { component_id: @component2.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not researched")
    end

    it "produce component + not enough credit" do
      put "/api/v1/colonies/#{@colony.id}/produce", params: { component_id: @component3.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not enough credits")
    end

    it "produce component + not enough resources" do
      put "/api/v1/colonies/#{@colony.id}/produce", params: { component_id: @component4.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not enough resources")
    end
  end
end