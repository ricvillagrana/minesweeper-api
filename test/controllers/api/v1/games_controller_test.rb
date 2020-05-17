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

  test 'POST /games/:id/reveal reveals the cell' do
    game = @user.games.create(bombs: 20, result: :playing)
    game.reveal!(0, 0)
    cell = game.cells.sample

    post api_v1_game_url(game.id) + '/reveal',
      params: { coord: cell.coord },
      headers: { 'User-ID': @user.id }
    assert_equal(response.parsed_body['board'].size, game.rows)
    assert_equal(response.parsed_body['board'][0].size, game.cols)
  end

  test 'POST /games/:id/flag flags the cell' do
    game = @user.games.create(bombs: 20, result: :playing)
    game.reveal!(0, 0)
    cell = game.cells.sample

    post api_v1_game_url(game.id) + '/flag',
      params: { coord: cell.coord },
      headers: { 'User-ID': @user.id }

    response_cell_status = response.parsed_body['board'][cell.coord[0]][cell.coord[1]]
    assert_equal('flag', response_cell_status)
  end

  test 'POST /games/:id/unflag unflags the cell' do
    game = @user.games.create(bombs: 20, result: :playing)
    game.reveal!(0, 0)
    cell = game.cells.sample
    cell.flag!

    post api_v1_game_url(game.id) + '/unflag',
      params: { coord: cell.coord },
      headers: { 'User-ID': @user.id }

    response_cell_status = response.parsed_body['board'][cell.coord[0]][cell.coord[1]]
    assert_equal('hidden', response_cell_status)
  end
end
