class CreateComponentResources < ActiveRecord::Migration[6.0]
  def change
    create_table :component_resources do |t|
      t.integer :amount, :default => 0
      t.belongs_to :component
      t.belongs_to :resource

      t.timestamps
    end

    add_index :component_resources, [:component_id, :resource_id], :unique =>  true
  end
end
