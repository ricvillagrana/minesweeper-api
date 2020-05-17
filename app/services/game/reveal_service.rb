class Game::RevealService
  def initialize(params)
    @game  = Game.find(params['game_id'])
    @coord = params['coord']
  end

  def process
    @game.send(action, @coord[0], @coord[1])
  end

  def action
    @game.cells.all?(&:hidden?) ? :start_on! : :reveal!
  end
end
