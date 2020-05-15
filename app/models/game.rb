class Game < ApplicationRecord
  belongs_to :user
  has_many :cells
  has_many :timers

  validates :result, inclusion: { in: %w(playing winner looser) }
end
