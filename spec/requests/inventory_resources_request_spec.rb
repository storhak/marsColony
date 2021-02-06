require 'rails_helper'
  
describe 'InventoryResources API', inventoryResource: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end

  describe 'PUT /inventory_resources/:id' do
    let!(:inventory) {FactoryBot.create(:inventory)}
    let!(:inventory2) {FactoryBot.create(:inventory)}
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}
    let!(:resource2) {FactoryBot.create(:resource, name: 'uranium')}
    let!(:inventoryResource) {FactoryBot.create(:inventory_resource, amount: 10, inventory_id: inventory.id, resource_id: resource.id)}
    let!(:inventoryResource2) {FactoryBot.create(:inventory_resource, amount: 80, inventory_id: @user.inventory.id, resource_id: resource2.id)}
    let!(:mine) {FactoryBot.create(:mine, name: 'test mine', user_id: @user.id, resource_id: resource.id, inventory_id: inventory.id)}
    let!(:type) {FactoryBot.create(:type, name: 'multiplier')}
    let!(:type2) {FactoryBot.create(:type, name: 'energyCap')}
    let!(:type3) {FactoryBot.create(:type, name: 'uraniumCost')}
    let!(:upgrade) {FactoryBot.create(:upgrade, name: 'double mining', description: 'increase mine amount', cost: 2000, value: 2, type_id: type.id)}
    let!(:upgrade2) {FactoryBot.create(:upgrade, name: 'double energycap', description: 'increase energycap', cost: 2000, value: 2, type_id: type2.id)}
    let!(:upgrade3) {FactoryBot.create(:upgrade, name: '-10 uranium cost', description: 'decrease energycost', cost: 2000, value: 10, type_id: type3.id)}
    let!(:mineUpgrade) {FactoryBot.create(:mine_upgrade, mine_id: mine.id, upgrade_id: upgrade.id, bought: true)}

    it "mine" do
      put "/api/v1/inventory_resources/#{inventoryResource.id}/mined", params: {  amount: 50 }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 110)
    end
    
    it "mine" do
      put "/api/v1/inventory_resources/#{inventoryResource.id}/mined", params: {  amount: 40 }, headers: @headers
      put "/api/v1/inventory_resources/#{inventoryResource.id}/mined", params: {  amount: 40 }, headers: @headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 140)
    end

    it "mine" do
      put "/api/v1/inventory_resources/#{inventoryResource.id}/mined", params: {  amount: 100 }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 160)
    end

    it "mine with energycap upgrade" do
      mineUpgrade2 = FactoryBot.create(:mine_upgrade, mine_id: mine.id, upgrade_id: upgrade2.id, bought: true)
      put "/api/v1/inventory_resources/#{inventoryResource.id}/mined", params: {  amount: 105 }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 215)
    end

    it "mine with energycost upgrade" do
      mineUpgrade3 = FactoryBot.create(:mine_upgrade, mine_id: mine.id, upgrade_id: upgrade3.id, bought: true)
      put "/api/v1/inventory_resources/#{inventoryResource.id}/mined", params: {  amount: 105 }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 215)
    end

    it "transfer a inventory_resource" do
      put "/api/v1/inventory_resources/#{inventoryResource.id}/transfer", params: {  inventory_id: inventory2.id , amount: 2 , resource_id: resource.id}, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("amount" => 2)
      expect(inventoryResource.amount==1)
    end

    it "transfer to much inventory_resource" do
      put "/api/v1/inventory_resources/#{inventoryResource.id}/transfer", params: {  inventory_id: inventory2.id , amount: 11 , resource_id: resource.id}, headers: @headers

      expect(JSON.parse(response.body)).to include("error" => "not enough resources")
      expect(inventoryResource.amount==10)
    end

    it "transfer to the same inventory" do
      inventory3 = FactoryBot.create(:inventory)
      inventoryResource2 = FactoryBot.create(:inventory_resource, amount: 3, inventory_id: inventory3.id, resource_id: resource.id)
      put "/api/v1/inventory_resources/#{inventoryResource2.id}/transfer", params: {  inventory_id: inventory3.id , amount: 2 , resource_id: resource.id}, headers: @headers

      expect(JSON.parse(response.body)).to include("error" => "cant trasfer to the same inventory")
      expect(inventoryResource2.amount==3)
    end
  end
end