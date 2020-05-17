class Game::BoardBuilder
  attr_reader :result

  def initialize(id)
    @game = Game.where(id: id).first
  end

  def build
    return blank_board if @game.cells.size.zero?

    @result = rows_range.map do |r|
      cols_range.map do |c|
        @game.cells.find_by(coord: [r, c]).state
      end
    end
  end

  private

  def blank_board
    @result = Array.new(@game.rows, Array.new(@game.cols, :hidden))
  end

  def rows_range
    (0..@game.rows - 1)
  end

  def cols_range
    (0..@game.cols - 1)
  end
end
