class AddLevelToUser < ActiveRecord::Migration
  def change
    add_column :users, :level, :integer

    User.all.each do |user|
      summoner = Summoner.find user.id
      user.name = summoner.name
      user.level = summoner.summonerLevel
      user.save!
    end
  end
end
