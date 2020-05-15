class Timer < ApplicationRecord
  belongs_to :game

  # Set the current time to started_at.
  def start
    update!(started_at: DateTime.now) if started_at.nil?
  end

  # Set the current time to stopped_at.
  def stop
    update!(stopped_at: DateTime.now) if started_at && stopped_at.nil?
  end

  # Returns the time between started_at and stopped_at in seconds,
  # or between started_at and the current time if the timer is not stopped
  def time
    return 0 if started_at.nil?

    if stopped_at
      stopped_at - started_at
    else
      DateTime.now.in_time_zone - started_at
    end
  end

  # Returns boolean value indicating if the timer has been stopped.
  def finished?
    !stopped_at.nil? && !started_at.nil?
  end
end
