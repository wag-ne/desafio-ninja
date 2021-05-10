class CreateSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :schedules do |t|
      t.references :room, null: false, foreign_key: true
      t.boolean :status
      t.datetime :start_at
      t.datetime :expires_at

      t.timestamps
    end
  end
end
