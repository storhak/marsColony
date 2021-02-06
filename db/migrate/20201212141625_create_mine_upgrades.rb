class CreateMineUpgrades < ActiveRecord::Migration[6.0]
  def change
    create_table :mine_upgrades do |t|
      t.boolean :bought, :default => false
      t.belongs_to :upgrade
      t.belongs_to :mine

      t.timestamps
    end
    
    add_index :mine_upgrades, [:mine_id, :upgrade_id], :unique =>  true
  end
end
