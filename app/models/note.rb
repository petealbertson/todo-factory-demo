class Note < ApplicationRecord
  belongs_to :todo

  validates :body, presence: true
end
