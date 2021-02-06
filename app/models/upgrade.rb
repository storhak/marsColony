class Upgrade < ApplicationRecord
  belongs_to :type
  has_many :mineUpgrades, dependent: :destroy
  has_many :mines, :through => :mineUpgrades

  validates :name, presence: true
  validates :description, presence: true
  validates :cost, presence: true
  validates :value, presence: true
end
