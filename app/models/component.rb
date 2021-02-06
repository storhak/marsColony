class Component < ApplicationRecord
  has_many :colonyComponents, dependent: :destroy
  has_many :colonies, :through => :colonyComponents
  
  has_many :inventoryComponents, dependent: :destroy
  has_many :inventories, :through => :inventoryComponents
  
  has_many :shipComponents, dependent: :destroy
  has_many :ships, :through => :shipComponents
  
  has_many :ComponentResources, dependent: :destroy
  has_many :resources, :through => :ComponentResources

  validates :name, presence: true
  validates :description, presence: true
end
