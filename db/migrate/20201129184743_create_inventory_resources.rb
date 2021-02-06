class CreateInventoryResources < ActiveRecord::Migration[6.0]
  def change
    create_table :inventory_resources do |t|
      t.integer :amount, :default => 0
      t.belongs_to :inventory
      t.belongs_to :resource

      t.timestamps
    end

    add_index :inventory_resources, [:inventory_id, :resource_id], :unique =>  true
  end
end
