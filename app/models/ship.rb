class Ship < ApplicationRecord
  has_many :spaceportShips, dependent: :destroy
  has_many :spaceports, :through => :spaceportShips

  has_many :inventoryShips, dependent: :destroy
  has_many :inventories, :through => :inventoryShips
  
  has_many :shipComponents, dependent: :destroy
  has_many :components, :through => :shipComponents
  
  validates :name, presence: true
end
