class CreateInventoryComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_components do |t|
      t.integer :amount, :default => 0
      t.belongs_to :inventory
      t.belongs_to :component

      t.timestamps
    end

    add_index :inventory_components, [:inventory_id, :component_id], :unique =>  true
  end
end
