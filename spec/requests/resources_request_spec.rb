require 'rails_helper'
  
describe 'Resources API', resource: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
    
    post '/api/v1/login', params: { username: 'test', password: 'pass' }
    data = JSON.parse(response.body)
    @headers = { "Authorization" => "bearer #{data["token"]}" }
  end

  describe 'GET /resources' do
    let!(:resource) {FactoryBot.create(:resource, name: 'iron')}

    it 'returns all resources' do
        get '/api/v1/resources', headers: @headers

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(1)  
    end

    it 'returns 1 resource' do
      get "/api/v1/resources/#{resource.id}", headers: @headers

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /resources' do
    it "create a new resource" do
      expect {
        post '/api/v1/resources', params: { resource: { name: 'test name'}}, headers: @headers
      }.to change { Resource.count }.from(0).to(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body).size).to eq(4)  
    end
  end

  describe 'PUT /resources/:id' do
    let!(:resource) {FactoryBot.create(:resource, name: 'tin')}

    it "update a resource" do
      put "/api/v1/resources/#{resource.id}", params: { resource: { name: 'copper'}}, headers: @headers

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /resources/:id' do
    let!(:resource) {FactoryBot.create(:resource, name: 'test name')}

    it "deletes a resource" do
      expect{
        delete "/api/v1/resources/#{resource.id}", headers: @headers
      }.to change { Resource.count }.from(1).to(0)

      expect(response).to have_http_status(:no_content)  
    end
  end
end