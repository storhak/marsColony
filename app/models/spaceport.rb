class Spaceport < ApplicationRecord
  belongs_to :user
  
  has_many :spaceportShips, dependent: :destroy
  has_many :ships, :through => :spaceportShips
end
