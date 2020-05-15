class CreateCells < ActiveRecord::Migration[6.0]
  def change
    create_table :cells, id: :uuid do |t|
      t.references :game, null: false, foreign_key: true, type: :uuid
      t.string :coord
      t.string :state, default: 'hidden'

      t.timestamps
    end
  end
end
