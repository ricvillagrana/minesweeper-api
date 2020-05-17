class Game::FlagService
  def initialize(params)
    @game  = Game.find(params['id'])
    @coord = params['coord']
  end

  def process
    @game.flag!(@coord[0], @coord[1])
  end
end
