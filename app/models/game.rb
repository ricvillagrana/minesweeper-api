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

  def state(x, y)
    cell(x, y).state
  end

  def cell(x, y)
    cells.find_by(coord: [x, y])
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

  private

  def init_board(cell)
    populate_bombs!(cell)
    timers.new.start
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
      bombs.times do
        cells
          .where(bomb: false, state: :hidden)
          .where.not(id: initial_cell.id)
          .sample.update!(bomb: true)
      end
    end
  end
end
