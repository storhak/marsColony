class Inventory < ApplicationRecord
  has_many :inventoryResources, dependent: :destroy
  has_many :resources, :through => :inventoryResources

  has_many :inventoryComponents, dependent: :destroy
  has_many :components, :through => :inventoryComponents

  has_many :inventoryShips, dependent: :destroy
  has_many :ships, :through => :inventoryShips
end
