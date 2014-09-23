require 'csv'

class TrollListImporter
  def self.execute!
    durations = [1, 3, 7, 14, 0]

    CSV.foreach('tmp/troll_list_dump.csv', headers: true) do |row|
      name = row['name']
      bans = {}
      durations.each do |d|
        bans[d] = {
          link: row["link#{d}"],
          reason: row["reason#{d}"]
        }
      end
      user = User.find_or_create(name: name)

      bans.each do |duration, ban|
        if ban[:link] && ban[:reason]
          Ban.create!(duration: duration, user: user, reason: ban[:reason], link: ban[:link], created_at: Time.parse('2014-09-01')) do |ref|
            Action.create!(tool_user: ToolUser.default_user, action: 'create', reference: ref, created_at: ref.created_at)
          end
        end
      end
      print "#{$.} lines read\r"
      sleep 1
    end
  end
end