class RemoveDateFromBans < ActiveRecord::Migration
  def change
    remove_column :bans, :date
  end
end
