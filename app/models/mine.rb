class Mine < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :inventory, dependent: :destroy
  
  has_many :mineUpgrades, dependent: :destroy
  has_many :upgrades, :through => :mineUpgrades
  
  validates :name, presence: true, length: { minimum: 3 }
end
