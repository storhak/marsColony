class CreateSpaceportShips < ActiveRecord::Migration[6.0]
  def change
    create_table :spaceport_ships do |t|
      t.boolean :researched, :default => false
      t.belongs_to :spaceport
      t.belongs_to :ship

      t.timestamps
    end
    
    add_index :spaceport_ships, [:spaceport_id, :ship_id], :unique =>  true
  end
end
