class Api::V1::GamesController < ApplicationController
  before_action :verify_user!

  # GET /api/v1/games
  #
  # returns an object with key +games+ containing an array of games.
  def index
    render json: { games: current_user.games }
  end

  # GET /api/v1/games/:id
  #
  # returns an object with key +game+ containing an game.
  def show
    render json: { game: current_user.games.find(params[:id]) }
  end

  # POST /api/v1/games/reveal
  #
  # receives an cell coord, a game_id and reveal it,
  # returns an new array board.
  def reveal
    reveal_service = Game::RevealService.new(reveal_params)
    reveal_service.process

    board_builder = Game::BoardBuilder.new(reveal_params['game_id'])
    board_builder.build
    binding.pry

    render json: { board: board_builder.result }
  rescue
    render json: { error: 'Cannot reveal that coordinates' }, status: :bad_request
  end

  # POST /api/v1/games
  #
  # receives an game object and creates it,
  # returns an object with key +game+ containing the created game.
  def create
    @game = current_user.games.create(game_params.merge(result: :playing))

    render json: { game: @game }
  end

  # DELETE /api/v1/games/:id
  #
  # receives an game id and destroys it by its id,
  # returns an object with key +game+ containing the deleted game.
  def destroy
    @game = current_user.games.find(params[:id])

    @game.destroy
    render json: { game: @game }
  rescue
    render json: { errors: @game.errors }, status: :bad_request
  end

  private

  def reveal_params
    params.permit!
  end

  def game_params
    params
      .require(:game)
      .permit(:bombs, :cols, :rows)
  end
end
