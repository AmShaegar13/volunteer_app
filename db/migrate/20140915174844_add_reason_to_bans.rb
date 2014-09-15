class AddReasonToBans < ActiveRecord::Migration
  def change
    add_column :bans, :reason, :string
  end
end
