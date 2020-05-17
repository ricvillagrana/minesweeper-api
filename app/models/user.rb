class User < ApplicationRecord
  has_many :games, dependent: :delete_all

  validates :name,     presence: true
  validates :username, presence: true, uniqueness: true
end
