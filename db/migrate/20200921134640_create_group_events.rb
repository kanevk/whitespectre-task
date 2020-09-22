class CreateGroupEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :group_events do |t|
      t.belongs_to :user, foreign_key: true
      t.string :name
      t.string :description
      t.string :description_format
      t.string :location
      t.integer :status, null: false
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration

      t.timestamps
    end
  end
end
