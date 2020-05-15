class Game < ApplicationRecord
  belongs_to :user

  validates :result, inclusion: { in: %w(playing winner looser) }
end
