require 'rails_helper'

describe "Upgrades API", upgrade: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end

  describe 'GET /upgrades' do
    let!(:type) {FactoryBot.create(:type, name: 'test')}
    let!(:upgrade) {FactoryBot.create(:upgrade, name: 'double mining', description: 'increase mine amount', cost: 5000, value: 1, type_id: type.id)}
    let!(:upgrade2) {FactoryBot.create(:upgrade, name: 'uranium', description: 'increase uranium multiplier', cost: 500000, value: 1, type_id: type.id)}

    it 'returns all upgrades' do
      get '/api/v1/upgrades', headers: @headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)  
    end

    it 'returns 1 upgrade' do
      get "/api/v1/upgrades/#{upgrade.id}", headers: @headers

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /upgrades' do
    let!(:type) {FactoryBot.create(:type, name: 'test')}

    it "create a new upgrade" do
      expect {
        post '/api/v1/upgrades', params: { upgrade: { name: 'double mining', description: 'increase mine amount', cost: 5000, value: 1, type_id: type.id}}, headers: @headers
      }.to change { Upgrade.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body).size).to eq(8)  
    end
  end

  describe 'PUT /upgrades/:id' do
    let!(:type) {FactoryBot.create(:type, name: 'test')}
    let!(:upgrade) {FactoryBot.create(:upgrade, name: 'double mining', description: 'increase mine amount', cost: 5000, value: 1, type_id: type.id)}

    it "update a upgrade" do
      put "/api/v1/upgrades/#{upgrade.id}", params: { upgrade: { name: 'uranium', description: 'increase uranium multiplier', cost: 500000, value: 2, type_id: type.id}}, headers: @headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /upgrades/:id' do
    let!(:type) {FactoryBot.create(:type, name: 'test')}
    let!(:upgrade) {FactoryBot.create(:upgrade, name: 'uranium', description: 'increase uranium multiplier', cost: 500000, value: 1, type_id: type.id)}

    it "deletes a upgrade" do
      expect{
      delete "/api/v1/upgrades/#{upgrade.id}", headers: @headers
      }.to change { Upgrade.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)  
    end
  end
end
