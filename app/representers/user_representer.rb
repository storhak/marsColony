class UserRepresenter
  def initialize(user)
    @user = user
  end

  def as_json()
    {
      user: getUser(user),
      colony: colony(user),
      spaceport: spaceport(user)
    }
  end

  def mines_as_json
    {
      user: getUser(user),
      mines: mines(user)
    }
  end


  

  private
  
  attr_reader :user
  def getUser(user)
    {
      id: user.id,
      name: user.name,
      balance: user.balance,
      inventory: inventory(user)
    }
  end

  def inventory(user)
    {
      id: user.inventory.id,
      resources: user.inventory.inventoryResources.map do |inventoryResource|
        {
          resource_id: inventoryResource.resource.id,
          name: inventoryResource.resource.name,
          amount: inventoryResource.amount
        }
      end,
      components: user.inventory.inventoryComponents.map do |inventoryComponent|
        {
          component_id: inventoryComponent.component.id,
          name: inventoryComponent.component.name,
          amount: inventoryComponent.amount
        }
      end,
      ships: user.inventory.inventoryShips.map do |inventoryShip|
        {
          ship_id: inventoryShip.ship.id,
          name: inventoryShip.ship.name,
          amount: inventoryShip.amount
        }
      end,
    }
  end

  def colony(user)
    {
      id: user.colony.id,
      components: user.colony.colonyComponents.map do |colonyComponent|
        {
          component_id: colonyComponent.component.id,
          name: colonyComponent.component.name,
          researched: colonyComponent.researched
        }
      end
    }
  end

  def mines(user)
    user.mines.map do |mine|
      {
        id: mine.id,
        name: mine.name,
        resource: mine.resource.name
      }
    end
  end

  def spaceport(user)
    {
      id: user.spaceport.id,
      ships: user.spaceport.spaceportShips.map do |spaceportShip|
        {
          ship_id: spaceportShip.ship.id,
          name: spaceportShip.ship.name,
          researched: spaceportShip.researched
        }
      end
    }
  end
end