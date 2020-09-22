class AddDeletedAtOnGroupEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :group_events, :deleted_at, :datetime
  end
end
