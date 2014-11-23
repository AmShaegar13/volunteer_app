require_relative '20140917220359_add_uniqueness_to_user_name'

class AddSummonerIdToUsers < ActiveRecord::Migration
  def up
    revert AddUniquenessToUserName
    add_column :users, :summoner_id, :integer

    User.update_all('summoner_id=id')

    say_with_time 'assign system generated ids' do
      new_id = 1
      User.all.each do |user|
        user.id = new_id
        user.save!
        new_id += 1
      end

      execute('ALTER TABLE users AUTO_INCREMENT = ' + new_id)
    end

    User.joins('JOIN users AS mains ON mains.summoner_id = users.main_id').update_all('users.main_id=mains.id')
    Ban.joins('JOIN users ON users.summoner_id = bans.user_id').update_all('bans.user_id=users.id')
    Action.joins('JOIN users ON reference_type = \'User\' AND users.summoner_id = actions.reference_id').update_all('actions.reference_id=users.id')

    add_index :users, [:summoner_id, :region], unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
