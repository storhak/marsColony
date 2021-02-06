class SpaceportRepresenter
  def initialize(spaceport)
    @spaceport = spaceport
  end

  def as_json
    {
      id: spaceport.id,
      ships: spaceport.spaceportShips.map do |spaceportShip|        
        {
          ship_id: spaceportShip.ship.id,
          name: spaceportShip.ship.name,
          research_cost: spaceportShip.ship.research_cost,
          build_cost: spaceportShip.ship.build_cost,
          build_time: spaceportShip.ship.build_time,
          researched: spaceportShip.researched,
          components: spaceportShip.ship.shipComponents.map do |shipComponent|
            {
              id: shipComponent.component.id,
              name: shipComponent.component.name,
              amount: shipComponent.amount
            }
          end
        }
      end,
      inventory: spaceport.user.inventory.inventoryShips.map do |inventoryShip|
        {
          ship_id: inventoryShip.ship.id,
          name: inventoryShip.ship.name,
          amount: inventoryShip.amount
        }
      end,
    }
  end

  private

  attr_reader :spaceport
end