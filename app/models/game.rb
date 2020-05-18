class Game < ApplicationRecord
  belongs_to :user
  has_many :cells, dependent: :delete_all
  has_many :timers, dependent: :delete_all

  validates :result, inclusion: { in: %w(playing winner looser) }
  validates :bombs, numericality: { greater_than: 1 }

  after_create :populate_cells

  def reveal!(x, y)
    c = cell(x, y)

    init_board(c) if cells.all?(&:hidden?)
    c.reveal!
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
    end
  end


  private

  def all_cells_revealed?
    cells.where(bomb: false).none? do |cell|
      cell.state.in? [:hidden, :flag]
    end
  end

  def no_bombs?
    cells.where(bomb: true).all? do |cell|
      cell.state.in? [:hidden, :flag]
    end
  end

  def init_board(cell)
    populate_bombs!(cell)
    timers.new.start!
  end

  def populate_cells
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
        .order("RANDOM() LIMIT #{bombs}")

      random_cells.update_all(bomb: true)
    end
  end
end
