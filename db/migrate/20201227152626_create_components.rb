class CreateComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :components do |t|
      t.string :name
      t.text :description
      t.integer :research_cost, :default => 2000
      t.integer :build_cost, :default => 500

      t.timestamps
    end
  end
end
