require 'rails_helper'

describe "SpaceportShips API", spaceportShip: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end
  
  describe 'GET /SpaceportShips' do
    let!(:spaceport) {FactoryBot.create(:spaceport, user_id: @user.id)}
    let!(:ship) {FactoryBot.create(:ship, name: "shuttle")}
    let!(:spaceportShip) {FactoryBot.create(:spaceport_ship, spaceport_id: spaceport.id, ship_id: ship.id)}

    it 'returns all SpaceportShips' do
      get '/api/v1/spaceport_ships', headers: @headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)  
    end
  end
end