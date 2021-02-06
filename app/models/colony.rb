class Colony < ApplicationRecord
  belongs_to :user
  
  has_many :colonyComponents, dependent: :destroy
  has_many :components, :through => :colonyComponents
end
