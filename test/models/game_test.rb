require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = User.first.games.create(bombs: 15, result: :playing)
  end

  test 'the game has no cells before start' do
    assert User.first.games.create.cells.count.zero?
  end

  test 'the games is populated after start' do
    assert_equal(@game.cells.count, @game.cols * @game.rows)
  end

  test 'the games is populated with bombs after first reveal' do
    @game.reveal!(3, 3)

    assert_equal(@game.bomb_cells.count, @game.bombs)
  end

  test 'the games won\'t populate again if reveal! is used again' do
    @game.reveal!(3, 4)

    assert_equal(@game.bomb_cells.count, @game.bombs)
  end

  test 'the method reveal! delegates to cell' do
    @game.reveal!(3, 3)
    @game.reveal!(5, 5)

    assert_not @game.cell(5, 5).hidden?
  end

  test 'the method flag! delegates to cell' do
    @game.flag!(5, 5)

    assert @game.cell(5, 5).flag?
  end

  test 'the method state brings the correct cell' do
    assert_equal(@game.state(5, 5), @game.cell(5, 5).state)
  end
end
