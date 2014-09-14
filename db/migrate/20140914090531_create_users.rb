class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, unique: true
      t.belongs_to :main

      t.timestamps
    end
  end
end
