require 'rails_helper'

describe "Ships API", ship: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }


    @ship = FactoryBot.create(:ship, name: "shuttle")
  end
  
  describe 'GET /Ships' do
    it 'returns all Ships' do
      get '/api/v1/ships', headers: @headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)  
    end
  end
end