class CreateShips < ActiveRecord::Migration[6.0]
  def change
    create_table :ships do |t|
      t.string :name
      t.integer :research_cost, :default => 2000
      t.integer :build_cost, :default => 500
      t.integer :build_time, :default => 60
      t.integer :carry_capacity, :default => 100

      t.timestamps
    end
  end
end
