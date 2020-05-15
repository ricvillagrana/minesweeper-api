class Timer < ApplicationRecord
  belongs_to :game

  validates :started_at, presence: true
end
