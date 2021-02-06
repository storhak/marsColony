class InventoriesRepresenter
  def initialize(inventories)
    @inventories = inventories
  end

  def as_json
    inventories.map do |inventory|
      {
        id: inventory.id,
        resources: inventory.inventoryResources
      }
    end
  end

  private
  
  attr_reader :inventories
end