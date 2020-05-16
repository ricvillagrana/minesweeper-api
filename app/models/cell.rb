class Cell < ApplicationRecord
  belongs_to :game

  serialize :coord

  validates :state, inclusion: {
    in: %w(hidden flag bomb exploded_bomb 0 1 2 3 4 5 6 7 8)
  }
  validates_each :coord do |record, attr, value|
    record.errors.add(attr, 'aready taken')\
      unless record.neighbors.select { |n| n&.coord == value }.empty?

    unless value.is_a?(Array) && value.length == 2
      record.errors.add(attr, 'should be an Array of length of 2')
    end
  end

  # Changes the state to :flag.
  def flag!
    update!(state: :flag)
  end

  # Updates state to :exploded_bomb or bomb_neighbors_count
  # if bomb_neighbors_count is 0, it also evaluates them.
  def reveal!
    new_state = bomb ? :exploded_bomb : bomb_neighbors_count
    update!(state: new_state)

    neighbors.each(&:reveal!) if bomb_neighbors_count.zero?
  end

  # Returns the number of neighbors that are a bomb.
  def bomb_neighbors_count
    neighbors.count { |neighbor| neighbor&.bomb }
  end

  # Returns neighbors instances or nil.
  def neighbors
    neighbors = neighbors_ranges[:x].flat_map do |x|
      neighbors_ranges[:y].flat_map do |y|
        game.cells.find_by(coord: [x, y])
      end
    end

    neighbors.filter { |neighbor| neighbor != self }
  end

  private

  # Returns neighbors range in coord.
  def neighbors_ranges
    {
      x: (coord[0] - 1 .. coord[0] + 1),
      y: (coord[1] - 1 .. coord[1] + 1)
    }
  end
end
