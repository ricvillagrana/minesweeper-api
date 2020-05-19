class Game < ApplicationRecord
  belongs_to :user
  has_many :cells, dependent: :delete_all
  has_many :timers, dependent: :delete_all

  validates :result, inclusion: { in: %w(playing winner looser) }
  validates :bombs, numericality: { greater_than: 1 }

  after_create :populate_cells!

  def reveal!(x, y)
    init_board(cell(x, y)) if cells.all?(&:hidden?)

    cell(x, y).reveal!
  end

  def flag!(x, y)
    cell(x, y).flag!
  end

  def unflag!(x, y)
    cell(x, y).unflag!
  end

  def state(x, y)
    cell(x, y).state
  end

  def cell(x, y)
    cells.find_by(coord: [x.to_i, y.to_i])
  end


  def bomb_cells
    cells.where(bomb: true)
  end

  def over!
    update!(result: :looser)

    bomb_cells.each do |cell|
      cell.update!(state: :bomb) unless cell.exploded_bomb?
    end
  end

  def win!
    update!(result: :winner)
  end

  def evaluate!
    if all_cells_revealed? && no_bombs?
      win!
      timers.last.stop!
    end
  end

  def no_hidden_but_bombs?
    cells.where(state: 'hidden', bomb: false).count.zero?
  end

  private

  def all_cells_revealed?
    cells.where(bomb: false).none? do |cell|
      cell.state.in? [:hidden, :flag]
    end
  end

  def no_bombs?
    cells.where(bomb: true).all? do |cell|
      cell.state.in? ['hidden', 'flag']
    end
  end

  def init_board(cell)
    populate_bombs!(cell)
    timers.new.start!
  end

  def populate_cells!
    rows.times do |row|
      cols.times do |col|
        cells.create(coord: [row, col])
      end
    end
  end

  def populate_bombs!(initial_cell)
    if bomb_cells.count < bombs
      random_cells = cells
        .where.not(id: initial_cell.id)
        .sample(bombs)

      random_cells.each do |cell|
        cell.update!(bomb: true)
        cell.neighbors.each { |n| n.increment!(:bombs_count) }
      end
    end
  end
end
