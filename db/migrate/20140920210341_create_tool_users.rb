class CreateToolUsers < ActiveRecord::Migration
  def change
    # do not forget :options => 'COLLATE=utf8_bin'
    create_table :tool_users do |t|
      t.string :name

      t.timestamps
    end
  end
end
