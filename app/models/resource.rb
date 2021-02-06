class Resource < ApplicationRecord
  has_many :mines, dependent: :destroy

  has_many :inventoryResources, dependent: :destroy
  has_many :inventories, :through => :inventoryResources
  
  has_many :ComponentResources, dependent: :destroy
  has_many :components, :through => :ComponentResources
  

  validates :name, presence: true
end
