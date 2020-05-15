class Cell < ApplicationRecord
  belongs_to :game

  serialize :coord

  validates :state, inclusion: {
    in: %w(hidden flag bomb exploded_bomb 0 1 2 3 4 5 6 7 8)
  }
  validates_each :coord do |record, attr, value|
    unless value.is_a?(Array) && value.length == 2
      record.errors.add(attr, 'should be an Array of length of 2')
    end
  end
end
