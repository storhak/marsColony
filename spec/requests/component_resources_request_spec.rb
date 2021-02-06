require 'rails_helper'

describe "ComponentResources API", componentResource: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end
  
  describe 'GET /ComponentResources' do
    let!(:resource) {FactoryBot.create(:resource, name: "iron")}
    let!(:component) {FactoryBot.create(:component, name: "test comp", description: "test desc")}
    let!(:componentResource) {FactoryBot.create(:component_resource, resource_id: resource.id, component_id: component.id)}

    it 'returns all ComponentResources' do
    get '/api/v1/component_resources', headers: @headers

    expect(response).to have_http_status(:success)
    expect(JSON.parse(response.body).size).to eq(1)  
    end
  end
end