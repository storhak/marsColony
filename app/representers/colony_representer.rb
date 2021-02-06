class ColonyRepresenter
  def initialize(colony, componentResources)
    @colony = colony
    @componentResources = componentResources
  end

  def as_json
    {
      id: colony.id,
      components: colony.colonyComponents.map do |colonyComponent|
        {
          component_id: colonyComponent.component.id,
          name: colonyComponent.component.name,
          research_cost: colonyComponent.component.research_cost,
          build_cost: colonyComponent.component.build_cost,
          researched: colonyComponent.researched,
          resource_cost: resources(colonyComponent).compact
        }
      end,
      inventory: colony.user.inventory.inventoryComponents.map do |inventoryComponent|
        {
          component_id: inventoryComponent.component.id,
          name: inventoryComponent.component.name,
          amount: inventoryComponent.amount
        }
      end,
    }
  end

  private

  attr_reader :colony, :componentResources

  def resources(colonyComponent)
      componentResources.map do |componentResource|
      if componentResource.component_id == colonyComponent.component.id
        {
          id: componentResource.id,
          resource_id: componentResource.resource_id,
          resource_name: componentResource.resource.name,
          amount: componentResource.amount
        }
      end
    end
  end
end