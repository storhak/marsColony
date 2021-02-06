require 'rails_helper'

describe "ColonyComponents API", colonyComponent: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end
  
  describe 'GET /ColonyComponents' do
    let!(:colony) {FactoryBot.create(:colony, user_id: @user.id)}
    let!(:component) {FactoryBot.create(:component, name: "test comp", description: "test desc")}
    let!(:colonyComponent) {FactoryBot.create(:colony_component, colony_id: colony.id, component_id: component.id)}

    it 'returns all ColonyComponents' do
    get '/api/v1/colony_components', headers: @headers

    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body).size).to eq(1)  
    end
  end
end
