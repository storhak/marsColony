class CreateShipComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :ship_components do |t|
      t.integer :amount, :default => 1
      t.belongs_to :ship
      t.belongs_to :component

      t.timestamps
    end
    
    add_index :ship_components, [:ship_id, :component_id], :unique =>  true
  end
end
