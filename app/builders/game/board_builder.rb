class Game::BoardBuilder
  attr_reader :result

  def initialize(game_id)
    @game = Game.where(id: game_id).first
  end

  def build
    @result = rows_range.map do |r|
      cols_range.map do |c|
        @game.cells.find_by(coord: [r, c]).state
      end
    end
  end

  private

  def rows_range
    (0..@game.rows - 1)
  end

  def cols_range
    (0..@game.cols - 1)
  end
end
