class CreateMines < ActiveRecord::Migration[6.0]
  def change
    create_table :mines do |t|
      t.string :name
      t.integer :uraniumCost, :default => 50
      t.integer :energy, :default => 0
      t.integer :energyCap, :default => 100
      t.integer :multiplier, :default => 1
      t.belongs_to :user
      t.belongs_to :resource
      t.belongs_to :inventory

      t.timestamps
    end
  end
end
