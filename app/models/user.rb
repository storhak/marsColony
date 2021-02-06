class User < ApplicationRecord
  has_secure_password
  
  has_many :mines, dependent: :destroy
  has_one :colony, dependent: :destroy
  has_one :spaceport, dependent: :destroy
  belongs_to :inventory, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3 }
  validates_uniqueness_of :name
end
