class Game::RevealService
  def initialize(params)
    @game  = Game.find(params['id'])
    @coord = params['coord']
  end

  def process
    @game.reveal!(@coord[0], @coord[1])
  end
end
