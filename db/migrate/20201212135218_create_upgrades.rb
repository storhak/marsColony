class CreateUpgrades < ActiveRecord::Migration[6.0]
  def change
    create_table :upgrades do |t|
      t.string :name
      t.text :description
      t.integer :cost
      t.integer :value
      t.belongs_to :type

      t.timestamps
    end
  end
end
