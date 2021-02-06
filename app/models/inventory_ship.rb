class InventoryShip < ApplicationRecord
  belongs_to :inventory
  belongs_to :ship

  validates :amount, presence: true
end