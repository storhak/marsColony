class SpaceportShip < ApplicationRecord
  belongs_to :spaceport
  belongs_to :ship
end
