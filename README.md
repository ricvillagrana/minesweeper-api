# Minesweeper API
Minesweeper game API built in Ruby on Rails.

## Models
Models definition.

### User
```
- uuid
- name
- username
+ games     # Returns an array of Games.
```

### Game
```
- uuid
- user_id
- rows
- cols
- finished      # For persisting this state and not evaluate each time the whole board.
- result        # Could be: [:winner, :looser].
+ board         # Returns an array of Cells.
+ reveal(x, y)  # Delegates to the Cell with coordinates x, y.
+ flag  (x, y)  # Delegates to the Cell with coordinates x, y.
+ state (x, y)  # Delegates to the Cell with coordinates x, y.
+ pause!        # Stops the last timer.
+ play!         # Starts a new timer.
+ over?         # Evaluates if revealed cells count equals to the board size minus the number of bombs in it.
+ looser?       # Evaluate if no cell has the :exploded_bomb status.
+ winner?       # Evaluates if
                #   - over? is true.
                #   - And looser? is false.
+ evaluate!     # Updates finished and result fields by running the over?, looser? and winner?.
+ total_time    # Returns the summation of all the times.
```

### Cell
```
- uuid
- game_id
- coord
- state           # Possible states: [:hidden, :flag, :bomb, :exploded_bomb, 0, 1, 2, 3, 4, 5, 6, 7, 8]
- bomb            # Indicates wheter a cell is a bomb.
+ reveal!         # If current status is :bomb changes to :exploded_bomb,
                  # but if it's :hidden,
                  # evaluates the state of the current Cell with count_neighbors.
                  # if new state is 0, then appply reveal to the eight neighbors.
+ flag!           # Change state of the current Cell to flag.

# private
+ count_neighbors # Return count of adjacent Cells with :bomb status.
```

### Timer
```
- uuid
- game_id
- started_at
- stopped_at
+ start!      # Set the current time to started_at.
+ stop!       # Set the current time to stopped_at.
+ time        # Returns the time between started_at and stopped_at in seconds.
```

## Concerns
Here are some known issues.
- Sessions are not handled securetly (just by giving a username you could access to another person games).
