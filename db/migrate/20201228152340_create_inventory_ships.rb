class CreateInventoryShips < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_ships do |t|
      t.integer :amount, :default => 0
      t.belongs_to :inventory
      t.belongs_to :ship

      t.timestamps
    end

    add_index :inventory_ships, [:inventory_id, :ship_id], :unique =>  true
  end
end
