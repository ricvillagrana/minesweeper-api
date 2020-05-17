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

  # POST /api/v1/games
  #
  # receives an game object and creates it,
  # returns an object with key +game+ containing the created game.
  def create
    @game = current_user.games.create(game_params)

    render json: { game: @game }
  end

  # PUT /api/v1/games/:id
  #
  # receives an game object and updates it by its id,
  # returns an object with key +game+ containing the updated game.
  def update
    @game = current_user.games.find(params[:id])

    @game.update!(game_params)
    render json: { game: @game }
  rescue
    render json: { errors: @game.errors }, status: :bad_request
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

  def game_params
    params
      .require(:game)
      .permit(:name, :gamename)
  end
end
