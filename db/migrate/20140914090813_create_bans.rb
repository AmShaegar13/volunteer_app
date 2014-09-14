class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.belongs_to :user
      t.datetime :date
      t.integer :duration

      t.timestamps
    end
  end
end
