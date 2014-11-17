require 'csv'

DEFAULT_LINK = 'http://forums.euw.leagueoflegends.com/board/showthread.php?t=0'

class TrollListOldImporter
  def self.execute!
    CSV.foreach('tmp/troll_list_old_dump.csv', headers: true) do |row|
      name = row['name']
      ban = {
          reason: row['reason'],
          duration: row['duration']
      }
      user = User.find_or_create_by!(name: name)

      if ban[:reason] && ban[:duration] && user
        Ban.create!(duration: ban[:duration], user: user, reason: ban[:reason], link: DEFAULT_LINK, created_at: Time.parse('2014-08-01')) do |ref|
          Action.create!(tool_user: ToolUser.default_user, action: 'create', reference: ref, created_at: ref.created_at)
        end
      end
      print "#{$.} lines read\r"
      sleep 1
    end
  end
end