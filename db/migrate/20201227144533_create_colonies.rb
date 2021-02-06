class CreateColonies < ActiveRecord::Migration[6.0]
  def change
    create_table :colonies do |t|
      t.belongs_to :user

      t.timestamps
    end
  end
end
