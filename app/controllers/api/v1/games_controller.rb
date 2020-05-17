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
  # returns an object with key +game+ containing an game and a board Array
  # that contains the board.
  def show
    render json: {
      game: current_user.games.find(params[:id]),
      board: board_game
    }
  end

  # POST /api/v1/games/:id/reveal
  #
  # receives an cell coord, a id and reveal it,
  # returns an new array board.
  def reveal
    reveal_service = Game::RevealService.new(permitted_params)
    reveal_service.process

    render json: { board: board_game }
  rescue
    render json: { error: 'Cannot reveal that coordinates' }, status: :bad_request
  end

  # POST /api/v1/games/:id/flag
  #
  # receives an cell coord, an id and flag it,
  # returns an new array board.
  def flag
    flag_service = Game::FlagService.new(permitted_params)
    flag_service.process

    render json: { board: board_game }
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

  def permitted_params
    params.permit!
  end

  def game_params
    params
      .require(:game)
      .permit(:bombs, :cols, :rows)
  end

  def board_game
    board_builder = Game::BoardBuilder.new(permitted_params['id'])
    board_builder.build
  end
end
