class InventoryComponent < ApplicationRecord
  belongs_to :inventory
  belongs_to :component

  validates :amount, presence: true
end
