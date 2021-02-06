require 'rails_helper'

describe "MineUpgrades API", mineUpgrade: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end

  describe 'GET /mine_upgrades' do
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}
    let!(:mine) {FactoryBot.create(:mine, name: 'test mine', user_id: @user.id, resource_id: resource.id, inventory_id: @inventory.id)}
    let!(:type) {FactoryBot.create(:type, name: 'test')}
    let!(:upgrade) {FactoryBot.create(:upgrade, name: 'double mining', description: 'increase mine amount', cost: 5000, value: 1, type_id: type.id)}
    let!(:upgrade2) {FactoryBot.create(:upgrade, name: 'triple mining', description: 'increase mine amount', cost: 5000000, value: 1, type_id: type.id)}
    let!(:mineUpgrade) {FactoryBot.create(:mine_upgrade, mine_id: mine.id, upgrade_id: upgrade.id)}
    let!(:mineUpgrade2) {FactoryBot.create(:mine_upgrade, mine_id: mine.id, upgrade_id: upgrade2.id)}

    it 'returns all mine_upgrades' do
      get '/api/v1/mine_upgrades', headers: @headers

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)  
    end
  end
end
