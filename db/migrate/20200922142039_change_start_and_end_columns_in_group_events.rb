class ChangeStartAndEndColumnsInGroupEvents < ActiveRecord::Migration[6.0]
  class GroupEvent < ApplicationRecord
  end

  def change
    add_column :group_events, :start_date, :date
    add_column :group_events, :end_date, :date


    reversible do |dir|
      dir.up do
        GroupEvent.update_all('start_date = start_time, end_date = end_time')
      end
    end

    remove_column :group_events, :start_time, :datetime
    remove_column :group_events, :end_time, :datetime
  end
end
