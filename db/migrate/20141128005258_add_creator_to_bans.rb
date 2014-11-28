class AddCreatorToBans < ActiveRecord::Migration
  def change
    add_reference :bans, :creator

    Ban.all.each do |ban|
      ban.creator = ban.actions.where(action: 'create').first.tool_user
      ban.save!
    end
  end
end
