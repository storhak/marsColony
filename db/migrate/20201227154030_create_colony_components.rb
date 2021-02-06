class CreateColonyComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :colony_components do |t|
      t.boolean :researched, :default => false
      t.belongs_to :colony
      t.belongs_to :component

      t.timestamps
    end
    
    add_index :colony_components, [:colony_id, :component_id], :unique =>  true
  end
end
