class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :rows, default: 8
      t.integer :cols, default: 8
      t.boolean :finished, default: false
      t.string :result, default: 'playing'

      t.timestamps
    end
  end
end
