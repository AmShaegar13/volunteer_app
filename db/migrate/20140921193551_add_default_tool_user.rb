class AddDefaultToolUser < ActiveRecord::Migration
  def up
    ToolUser.create! id: -1, name: 'default'
  end

  def down
    ToolUser.find_by_name('default').destroy
  end
end
