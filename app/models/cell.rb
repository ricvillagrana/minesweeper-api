class Cell < ApplicationRecord
  belongs_to :game

  serialize :coord

  validates :state, inclusion: {
    in: %w(hidden flag bomb exploded_bomb 0 1 2 3 4 5 6 7 8)
  }
  validates_each :coord do |record, attr, value|
    record.errors.add(attr, 'aready taken')\
      if !record.persisted? && !record.game.cells.select do |n|
        n&.coord == value
      end.empty?

    unless value.is_a?(Array) && value.length == 2
      record.errors.add(attr, 'should be an Array of length of 2')
    end
  end

  after_commit :check_bomb, on: [:update]

  # Changes the state to :flag.
  def flag!
    update!(state: :flag)
  end

  # Changes the state to :hidden if it's :flag.
  def unflag!
    update!(state: :hidden) if flag?
  end

  # Updates state to :exploded_bomb or bomb_neighbors_count
  # if bomb_neighbors_count is 0, it also evaluates them.
  def reveal!
    return unless hidden?

    new_state = bomb ? :exploded_bomb : bombs_count
    update!(state: new_state)

    neighbors
      .select { |n| !n.nil? && n.state == 'hidden' && !n.bomb }
      .each(&:reveal!) if bombs_count.zero?
    game.evaluate! if game.no_hidden_but_bombs?
  end

  # Returns the number of neighbors that are a bomb.
  def bomb_neighbors_count
    neighbors.count { |neighbor| neighbor&.bomb }
  end

  # Returns neighbors instances or nil.
  def neighbors
    coords = neighbors_ranges[:x].map do |x|
      neighbors_ranges[:y].map do |y|
        [x, y]
      end
    end

    coords.flatten!(1)
    game.cells.select { |c| c.coord.in?(coords) }
  end

  def hidden?
    state == 'hidden'
  end

  def flag?
    state == 'flag'
  end

  def exploded_bomb?
    state == 'exploded_bomb'
  end

  private

  # Returns neighbors range in coord.
  def neighbors_ranges
    {
      x: (coord[0] - 1 .. coord[0] + 1),
      y: (coord[1] - 1 .. coord[1] + 1)
    }
  end

  def check_bomb
    game.over! if exploded_bomb?
  end
end
