class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.belongs_to :tool_user
      t.string :action
      t.references :reference, polymorphic: true

      t.timestamps
    end
  end
end
