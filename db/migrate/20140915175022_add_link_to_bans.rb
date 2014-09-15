class AddLinkToBans < ActiveRecord::Migration
  def change
    add_column :bans, :link, :string
  end
end
