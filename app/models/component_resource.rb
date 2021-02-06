class ComponentResource < ApplicationRecord
  belongs_to :component
  belongs_to :resource

  validates :amount, presence: true
end
