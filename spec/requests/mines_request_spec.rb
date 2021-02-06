require 'rails_helper'
  
describe 'Mines API', mine: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end

  describe 'GET /mines' do
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}
    let!(:mine) {FactoryBot.create(:mine, name: 'test mine', user_id: @user.id, resource_id: resource.id, inventory_id: @inventory.id)}

    it 'returns all mines' do
      get '/api/v1/mines', headers: @headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)  
    end

    it 'returns 1 mine' do
      get "/api/v1/mines/#{mine.id}", headers: @headers

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /mines' do
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}

    it "create a new mine" do
      expect {
        post '/api/v1/mines', params: { mine: { name: 'tin name', user_id: @user.id, resource_id: resource.id }}, headers: @headers
      }.to change { Mine.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe 'PUT /mines/:id' do
    let!(:user2) {FactoryBot.create(:user, name: 'test user2', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 300.60, inventory_id: @inventory.id)}
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}
    let!(:mine) {FactoryBot.create(:mine, name: 'test mine', user_id: @user.id, resource_id: resource.id, inventory_id: @inventory.id)}

    it "update a mine" do
      put "/api/v1/mines/#{mine.id}", params: { mine: { name: 'test name2', user_id: user2.id, resource_id: resource.id, energyCap: 200, inventory_id: @inventory.id }}, headers: @headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'buy upgrade' do
    let!(:user2) {FactoryBot.create(:user, name: 'test user2', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 5001, inventory_id: @inventory.id)}
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}
    let!(:mine) {FactoryBot.create(:mine, name: 'test mine', user_id: @user.id, resource_id: resource.id, inventory_id: @inventory.id)}
    let!(:type) {FactoryBot.create(:type, name: 'test')}
    let!(:upgrade) {FactoryBot.create(:upgrade, name: 'double mining', description: 'increase mine amount', cost: 5000, value: 1, type_id: type.id)}
    let!(:upgrade2) {FactoryBot.create(:upgrade, name: 'double mining', description: 'increase mine amount', cost: 10, value: 1, type_id: type.id)}
    let!(:mineUpgrade) {FactoryBot.create(:mine_upgrade, mine_id: mine.id, upgrade_id: upgrade.id)}
    let!(:mineUpgrade2) {FactoryBot.create(:mine_upgrade, mine_id: mine.id, upgrade_id: upgrade2.id)}

    it "buy upgrade + not enough credit" do
      put "/api/v1/mines/#{mine.id}/buy", params: { upgrade_id: upgrade.id }, headers: @headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("error" => "not enough credits")
    end

    it "buy upgrade" do
      put "/api/v1/mines/#{mine.id}/buy", params: { upgrade_id: upgrade2.id }, headers: @headers
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("bought" => true)
    end
  end

  describe 'DELETE /mines/:id' do
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}
    let!(:mine) {FactoryBot.create(:mine, name: 'test mine', user_id: @user.id, resource_id: resource.id, inventory_id: @inventory.id)}

    it "deletes a mine" do
      expect{
        delete "/api/v1/mines/#{mine.id}", headers: @headers
      }.to change { Mine.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)  
    end

    it "deletes a user with mine" do
      expect{
        delete "/api/v1/users/#{@user.id}", headers: @headers
      }.to change { Mine.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)  
    end

    it "deletes a resource with mine" do
      expect{
        delete "/api/v1/resources/#{resource.id}", headers: @headers
      }.to change { Mine.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)  
    end
  end
end