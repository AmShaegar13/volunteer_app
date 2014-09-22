class ChangePermaDurationToZero < ActiveRecord::Migration
  def up
    Ban.where(duration: -1).each do |ban|
      ban.duration = 0
      ban.save!
    end
  end


  def down
    Ban.where(duration: 0).each do |ban|
      ban.duration = -1
      ban.save!
    end
  end
end
