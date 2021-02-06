class MinesRepresenter
  def initialize(mines)
    @mines = mines
  end

  def as_json
    mines.map do |mine|
      {
        id: mine.id,
        name: mine.name,
        resource: mine.resource.name,
        resource_id: mine.resource_id,
        user_id: mine.user_id,
        inventory_id: mine.inventory_id,
        energyCap: mine.energyCap, 
        energy: mine.energy, 
        multiplier: mine.multiplier
      }
    end
  end

  private

  attr_reader :mines
end