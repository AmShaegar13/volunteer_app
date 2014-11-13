class CreateUsers < ActiveRecord::Migration
  def change
    # do not forget :options => 'COLLATE=utf8_bin'
    create_table :users do |t|
      t.string :name, unique: true
      t.belongs_to :main

      t.timestamps
    end
  end
end
