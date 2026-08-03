class Tag < ApplicationRecord
  belongs_to :todo

  validates :name, presence: true
end
