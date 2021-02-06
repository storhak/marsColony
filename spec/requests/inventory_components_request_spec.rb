require 'rails_helper'

describe "InventoryComponents API", inventoryComponent: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end
  
  describe 'GET /InventoryComponents' do
    let!(:colony) {FactoryBot.create(:colony, user_id: @user.id)}
    let!(:component) {FactoryBot.create(:component, name: "test comp", description: "test desc")}
    let!(:inventoryComponent) {FactoryBot.create(:inventory_component, inventory_id: @inventory.id, component_id: component.id)}

    it 'returns all InventoryComponents' do
    get '/api/v1/inventory_components', headers: @headers

    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body).size).to eq(1)  
    end
  end
end