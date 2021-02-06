class Type < ApplicationRecord
  has_many :upgrades, dependent: :destroy

  validates :name, presence: true
end
