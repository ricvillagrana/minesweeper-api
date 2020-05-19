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
- I did not follow GitFlow due to I am working on this alone, but the ideal way to work is by following the Git [Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow).
- Sessions are not handled securetly (just by giving a username you could access to another person games).
- The timer is working but was not implemented on the UI.
