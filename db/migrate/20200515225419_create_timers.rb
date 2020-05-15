class CreateTimers < ActiveRecord::Migration[6.0]
  def change
    create_table :timers, id: :uuid do |t|
      t.references :game, null: false, foreign_key: true, type: :uuid
      t.datetime :started_at
      t.datetime :stopped_at
    end
  end
end
