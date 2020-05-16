require 'test_helper'

class CellTest < ActiveSupport::TestCase
  def setup
    game = User.first.games.create(cols: 5, rows: 5, bombs: 5, result: :playing)
    @cell = game.cells.sample
  end

  test 'the cell is incorrect if coord array is another size than two' do
    assert_not Cell.new(game: Game.first, coord: [0, 0, 0]).save
  end

  test 'the cell is incorrect if coord is not an array' do
    assert_not Cell.new(game: Game.first, coord: [0, 0, 0]).save
  end

  test 'the flag! method updates the state to flag' do
    @cell.flag!

    assert @cell.flag?
  end

  test 'the bomb_neighbors_count method to return correct number' do
    count = @cell.neighbors.count { |neighbor| neighbor&.bomb }

    assert @cell.bomb_neighbors_count == count
  end

  test 'the neighbors method to return correct number' do
    assert @cell.neighbors.count == 8
  end

  test 'the method hidden?' do
    @cell.update!(state: :hidden)

    assert @cell.hidden?
  end

  test 'the method flag?' do
    @cell.update!(state: :flag)

    assert @cell.flag?
  end

  test 'the method exploded_bomb?' do
    @cell.update!(state: :exploded_bomb)

    assert @cell.exploded_bomb?
  end

  test 'the method reveal! only work on hidden cells' do
    @cell.update!(state: :flag)
    @cell.reveal!

    assert @cell.flag?
  end

  test 'the method reveal! change the state to exploted_bomb if it\'s a bomb' do
    @cell.update!(state: :hidden, bomb: true)
    @cell.reveal!

    assert @cell.exploded_bomb?
  end
end
