require 'rails_helper'
  
describe 'Users API', user: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }


    @colony = FactoryBot.create(:colony, user_id: @user.id)
    @spaceport = FactoryBot.create(:spaceport, user_id: @user.id)
  end

  describe 'GET /users' do
    let!(:user2) {FactoryBot.create(:user, name: 'test2', password_digest: 'pass', balance: 3000.54, inventory_id: @inventory.id)}

    it 'returns all users' do
        get '/api/v1/users', headers: @headers

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(2)  
    end

    it 'returns 1 user' do
      get "/api/v1/users/#{@user.id}", headers: @headers

      expect(response).to have_http_status(:success)
    end

    it 'returns 1 user with mines' do
      get "/api/v1/users/#{@user.id}/showMines", headers: @headers

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /auto_login" do
    it "try to autologin" do
      get "/api/v1/auto_login", headers: @headers
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("name")
    end
  end

  describe 'POST /users' do
    let!(:component) {FactoryBot.create(:component, name: "test comp", description: "test desc")}
    let!(:component2) {FactoryBot.create(:component, name: "test comp2", description: "test desc2")}

    it "create a new user" do
      expect {
        post '/api/v1/users', params: { user: { name: 'test name', password: 'pass', balance: 300.5 }}
      }.to change { User.count }.from(1).to(2)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("user")
      expect(Inventory.count).to eq(2)
      expect(Colony.count).to eq(2)
      expect(Component.count).to eq(2)
      expect(InventoryComponent.count).to eq(2)
      expect(ColonyComponent.count).to eq(2)
      expect(Spaceport.count).to eq(2)
    end
  end

  describe 'POST /login' do
    let!(:inventory) {FactoryBot.create(:inventory)}
    let!(:user) {FactoryBot.create(:user, name: 'test2', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", inventory_id: inventory.id)}

    it "a good login" do
      post '/api/v1/login', params: { username: 'test', password: 'pass' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("user")
    end

    it "login with no username" do
      post '/api/v1/login', params: { password: 'pass' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("error" => "Invalid username or password")
    end

    it "login with no password" do
      post '/api/v1/login', params: { username: 'test' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("error" => "Invalid username or password")
    end

    it "login with wrong password" do
      post '/api/v1/login', params: { username: 'test', password: 'pasrzers' }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("error" => "Invalid username or password")
    end
  end

  describe 'PUT /users/:id' do
    it "update a user" do
      put "/api/v1/users/#{@user.id}", params: { user: { name: 'test name2', balance: 300.5 }}, headers: @headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /users/:id' do
    it "deletes a user" do
      expect{
        delete "/api/v1/users/#{@user.id}", headers: @headers
      }.to change { User.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)  
    end

    it "deletes a user with colony" do
      expect{
        delete "/api/v1/users/#{@user.id}", headers: @headers
      }.to change { User.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)
      expect(Colony.count).to eq(0)
      expect(Spaceport.count).to eq(0)
    end
  end
end