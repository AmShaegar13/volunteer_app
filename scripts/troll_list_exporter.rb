require 'csv'

class TrollListExporter
  def self.execute!
    CSV.open('tmp/troll_list_export.csv', 'w') do |csv|
      bans = Ban.all
      csv << bans.first.attributes.keys + %W(summoner creator)

      puts

      count, all = 0, bans.size

      bans.each do |ban|

        csv << ban.attributes.values + [ban.user.name, ban.creator.name]
        count += 1
        print "\r%.2f %% done...   " % [100.0*count/all]
      end
    end

    puts
  end
end