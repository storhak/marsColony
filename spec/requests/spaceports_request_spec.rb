require 'rails_helper'

describe "Spaceports API", spaceport: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }


    @colony = FactoryBot.create(:colony, user_id: @user.id)
    @spaceport = FactoryBot.create(:spaceport, user_id: @user.id)
  end
  
  describe 'GET /Spaceports' do
    it 'returns all Spaceports' do
      get '/api/v1/spaceports', headers: @headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)  
    end

    it 'returns 1 spaceport' do
      get "/api/v1/spaceports/#{@spaceport.id}", headers: @headers

      expect(response).to have_http_status(:success)
    end
  end

  describe 'research ship' do
    before do
      @ship = FactoryBot.create(:ship, name: "shuttle")
      @ship2 = FactoryBot.create(:ship, name: "frigate", research_cost: 5000)
      @spaceportShip = FactoryBot.create(:spaceport_ship, spaceport_id: @spaceport.id, ship_id: @ship.id)
      @spaceportShip2 = FactoryBot.create(:spaceport_ship, spaceport_id: @spaceport.id, ship_id: @ship2.id)
    end
    

    it "research ship" do
      put "/api/v1/spaceports/#{@spaceport.id}/research", params: { ship_id: @ship.id }, headers: @headers
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("researched" => true)
    end

    it "research ship + not enough credit" do
      put "/api/v1/spaceports/#{@spaceport.id}/research", params: { ship_id: @ship2.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not enough credits")
    end
  end

  describe 'produce ship' do
    before do
      @component = FactoryBot.create(:component, name: "comp1", description: "test desc")
      @component2 = FactoryBot.create(:component, name: "comp2", description: "test desc")
      @inventoryComponent = FactoryBot.create(:inventory_component, inventory_id:  @inventory.id, component_id: @component.id, amount: 10)
      @inventoryComponent2 = FactoryBot.create(:inventory_component, inventory_id:  @inventory.id, component_id: @component2.id, amount: 10)
      @ship1 = FactoryBot.create(:ship, name: "shuttle1", build_cost: 1000)
      @ship2 = FactoryBot.create(:ship, name: "shuttle2")
      @ship3 = FactoryBot.create(:ship, name: "shuttle3", build_cost: 500000)
      @ship4 = FactoryBot.create(:ship, name: "shuttle4")
      @spaceportShip = FactoryBot.create(:spaceport_ship, spaceport_id: @spaceport.id, ship_id: @ship1.id, researched: true)
      @spaceportShip2 = FactoryBot.create(:spaceport_ship, spaceport_id: @spaceport.id, ship_id: @ship2.id)
      @spaceportShip3 = FactoryBot.create(:spaceport_ship, spaceport_id: @spaceport.id, ship_id: @ship3.id, researched: true)
      @spaceportShip4 = FactoryBot.create(:spaceport_ship, spaceport_id: @spaceport.id, ship_id: @ship4.id, researched: true)

      @inventoryShip = FactoryBot.create(:inventory_ship, inventory_id: @inventory.id, ship_id: @ship1.id)
      @inventoryShip4 = FactoryBot.create(:inventory_ship, inventory_id: @inventory.id, ship_id: @ship4.id)

      @shipComponent = FactoryBot.create(:ship_component, ship_id: @ship1.id, component_id: @component.id, amount: 10)
      @shipComponent2 = FactoryBot.create(:ship_component, ship_id: @ship1.id, component_id: @component2.id, amount: 8)
      @ship4Component = FactoryBot.create(:ship_component, ship_id: @ship4.id, component_id: @component.id, amount: 10)
      @ship4Component2 = FactoryBot.create(:ship_component, ship_id: @ship4.id, component_id: @component2.id, amount: 11)
    end
    

    it "produce ship" do
      put "/api/v1/spaceports/#{@spaceport.id}/produce", params: { ship_id: @ship1.id }, headers: @headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 1)
      
      get "/api/v1/users/#{@user.id}", headers: @headers
      expect(JSON.parse(response.body).fetch("user")).to include("balance" => 3000)
      expect(JSON.parse(response.body).fetch("user").fetch("inventory").fetch("ships").fetch(0)).to include("name" => "shuttle1", "amount" => 1)
      expect(JSON.parse(response.body).fetch("user").fetch("inventory").fetch("components").fetch(0)).to include("name" => "comp1", "amount" => 0)
      expect(JSON.parse(response.body).fetch("user").fetch("inventory").fetch("components").fetch(1)).to include("name" => "comp2", "amount" => 2)
    end

    it "produce ship + not researched" do
      put "/api/v1/spaceports/#{@spaceport.id}/produce", params: { ship_id: @ship2.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not researched")
    end

    it "produce ship + not enough credit" do
      put "/api/v1/spaceports/#{@spaceport.id}/produce", params: { ship_id: @ship3.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not enough credits")
    end

    it "produce ship + not enough components" do
      put "/api/v1/spaceports/#{@spaceport.id}/produce", params: { ship_id: @ship4.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not enough components")
    end
  end
end