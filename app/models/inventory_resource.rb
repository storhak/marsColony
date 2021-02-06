class InventoryResource < ApplicationRecord
  belongs_to :inventory
  belongs_to :resource

  validates :amount, presence: true
end
