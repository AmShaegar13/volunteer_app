class ChangeCollation < ActiveRecord::Migration

  TABLES_TO_ALTER = %w(actions bans users tool_users)

  def up
    TABLES_TO_ALTER.each do |table|
      connection.execute('alter table %s convert to character set utf8 collate utf8_bin' % [table])
    end
  end

  def down
    TABLES_TO_ALTER.each do |table|
      connection.execute('alter table %s convert to character set utf8 collate utf8_unicode_ci' % [table])
    end
  end
end
