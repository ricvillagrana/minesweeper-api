class Game < ApplicationRecord
  belongs_to :user
  has_many :cells

  validates :result, inclusion: { in: %w(playing winner looser) }
end
