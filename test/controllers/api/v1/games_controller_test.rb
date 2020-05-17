require 'test_helper'

class Api::V1::GamesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.first
  end

  test 'GET /games succeed' do
    get api_v1_games_url, headers: { 'User-ID': @user.id }

    assert_response :success
    assert_equal(response.parsed_body['games'].count, @user.games.count)
  end

  test 'GET /games response contain same amount of games than the model' do
    get api_v1_games_url, headers: { 'User-ID': @user.id }
    assert_equal(response.parsed_body['games'].count, @user.games.count)
  end

  test 'GET /games/:id response with the correct game' do
    game = @user.games.all.sample

    get api_v1_game_url(game.id), headers: { 'User-ID': @user.id }
    assert_equal(response.parsed_body['game']['id'], game.id)
  end

  test 'POST /games/ creates a new game' do
    game        = { bombs: 5 }
    games_count = @user.games.count

    post api_v1_games_url, params: { game: game },
      headers: { 'User-ID': @user.id }
    assert_equal(@user.games.count, games_count + 1)
  end

  test 'DELETE /games/:id deletes the user' do
    game = @user.games.create(bombs: 20, result: :playing)

    delete api_v1_game_url(game.id), headers: { 'User-ID': @user.id }
    assert_equal(response.parsed_body['game']['id'], game.id)
  end
end
