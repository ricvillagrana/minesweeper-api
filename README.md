# Minesweeper API
Minesweeper game API built in Ruby on Rails.

## Notes
- The board generation was extracted to a Builder pattern.
- The reveal, flag and unflag actions were  extracted to Service pattern.
- The bomb count was changed from count on each reveal evaluation to increment a `bombs_count` (for the neighbors) value when a bomb is planted.
- The timer is working but was not implemented on the UI.
- To generate documentation, please use `rdoc` on the root of this folder's repo.

## Concerns
Here are some known issues.
- Sessions are not handled securetly (just by giving a username you could access to another person games).
- The timer is working but was not implemented on the UI.
