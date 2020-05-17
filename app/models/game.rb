class Game < ApplicationRecord
  belongs_to :user
  has_many :cells, dependent: :delete_all
  has_many :timers, dependent: :delete_all

  validates :result, inclusion: { in: %w(playing winner looser) }
  validates :bombs, numericality: { greater_than: 1 }

  after_create :populate_cells

  def start_on!(x, y)
    return false unless cells.all?(&:hidden?)

    initial_cell = cell(x, y)

    initial_cell.update!(state: :flag)
    populate_bombs!
    initial_cell.reveal!
  end

  def reveal!(x, y)
    cell(x, y).reveal!
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

  def populate_cells
    rows.times do |row|
      cols.times do |col|
        cells.create(coord: [row, col])
      end
    end
  end

  def populate_bombs!
    if bomb_cells.count < bombs
      bombs.times do
        cells.where(bomb: false, state: :hidden).sample.update!(bomb: true)
      end
    end
  end
end
