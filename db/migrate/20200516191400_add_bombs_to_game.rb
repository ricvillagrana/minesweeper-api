class AddBombsToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :bombs, :integer
  end
end
