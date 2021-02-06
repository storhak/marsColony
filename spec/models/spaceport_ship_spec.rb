require 'rails_helper'

describe "SpaceportShip Model", spaceportShip: :request do
  before do
    @inventory = FactoryBot.create(:inventory)
    @user = FactoryBot.create(:user, name: 'test', password_digest: "#{BCrypt::Password.create("pass", :cost => 11)}", balance: 4000,inventory_id: @inventory.id)
  end
  
  
  describe 'delete' do
    before do
      @spaceport = FactoryBot.create(:spaceport, user_id: @user.id)
      @ship = FactoryBot.create(:ship, name: "shuttle")
      @spaceportShip = FactoryBot.create(:spaceport_ship, spaceport_id:  @spaceport.id, ship_id: @ship.id)
    end
    

    it 'delete spaceportShip' do
      expect(Spaceport.count).to eq(1)
      expect(Ship.count).to eq(1)
      expect(SpaceportShip.count).to eq(1)

      @spaceportShip.destroy

      expect(SpaceportShip.count).to eq(0)
      expect(Spaceport.count).to eq(1)
      expect(Ship.count).to eq(1)
    end

    it 'delete spaceport with spaceportShip' do
      expect(Spaceport.count).to eq(1)
      expect(Ship.count).to eq(1)
      expect(SpaceportShip.count).to eq(1)

      @spaceport.destroy
      
      expect(SpaceportShip.count).to eq(0)
      expect(Spaceport.count).to eq(0)
      expect(Ship.count).to eq(1)
    end

    it 'delete ship with spaceportShip' do
      expect(Spaceport.count).to eq(1)
      expect(Ship.count).to eq(1)
      expect(SpaceportShip.count).to eq(1)

      @ship.destroy
      
      expect(SpaceportShip.count).to eq(0)
      expect(Spaceport.count).to eq(1)
      expect(Ship.count).to eq(0)
    end
  end
end