require 'test_helper'

class TimerTest < ActiveSupport::TestCase
  def setup
    @timer = Game.first.timers.new
  end

  test 'the timer saves when it belongs to a Game' do
    assert Timer.new(game: Game.first).save
  end

  test 'the timer does not save when it does not belong to a Game' do
    assert_not Timer.new.save
  end

  test 'the timer starts when the method start is called' do
    @timer.start!

    assert_not @timer.started_at.nil?
  end

  test 'the timer stops when the method stop is called' do
    @timer.start!
    @timer.stop!

    assert_not @timer.stopped_at.nil?
  end

  test 'the timer cannot be stopped if it has not been started before' do
    @timer.stop!

    assert @timer.stopped_at.nil?
  end

  test 'the timer shows zero seconds when started_at is nil' do
    assert @timer.time.zero?
  end

  test 'the timer shows the current seconds' do
    @timer.start!
    sleep 0.03

    assert @timer.time >= 0.03
    assert @timer.time <  0.05
  end

  test 'the timer shows the difference between stopped_at and started_at' do
    @timer.start!
    sleep 0.05
    @timer.stop!

    assert @timer.time == @timer.stopped_at - @timer.started_at
  end

  test 'the timer indicates when the timer is not finished' do
    @timer.start!

    assert_not @timer.finished?
  end

  test 'the timer indicates when the timer is finished' do
    @timer.start!
    @timer.stop!

    assert @timer.finished?
  end
end
