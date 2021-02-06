class MineRepresenter
  def initialize(mine)
    @mine = mine
  end

  def as_json
    {
      id: mine.id,
      name: mine.name,
      resource: mine.resource.name,
      resource_id: mine.resource_id,
      user_id: mine.user_id,
      uraniumCost: mine.uraniumCost, 
      energyCap: mine.energyCap, 
      energy: mine.energy, 
      multiplier: mine.multiplier,
      user_currency: mine.user.balance,
      inventory: inventory(mine),
      upgrades: upgrades(mine)
    }
  end

  private

  attr_reader :mine

  def inventory(mine)
    {
      id: mine.inventory.id,
      resources: mine.inventory.inventoryResources.map do |inventoryResource|
        {
          inventory_resource_id: inventoryResource.id,
          amount: inventoryResource.amount,
          name: inventoryResource.resource.name,
          resource_id: inventoryResource.resource.id
        }
      end
    }
  end

  def upgrades(mine)
    mine.mineUpgrades.map do |mineUpgrade|
      {
        upgrade_id: mineUpgrade.upgrade.id,
        name: mineUpgrade.upgrade.name,
        description: mineUpgrade.upgrade.description,
        value: mineUpgrade.upgrade.value,
        cost: mineUpgrade.upgrade.cost,
        bought: mineUpgrade.bought
      }
    end
  end
end