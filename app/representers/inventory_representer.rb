class InventoryRepresenter
  def initialize(inventory)
    @inventory = inventory
  end

  def as_json
    {
      id: inventory.id,
      resources: inventory.inventoryResources
    }
  end

  private
  
  attr_reader :inventory
end