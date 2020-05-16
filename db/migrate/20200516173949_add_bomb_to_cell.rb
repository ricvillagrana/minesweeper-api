class AddBombToCell < ActiveRecord::Migration[6.0]
  def change
    add_column :cells, :bomb, :boolean, default: false
  end
end
