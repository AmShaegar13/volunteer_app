class AddRegionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :region, :string

    reversible do |dir|
      dir.up do
        User.update_all region: 'euw'
      end
    end
  end
end
