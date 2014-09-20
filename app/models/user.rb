class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id', dependent: :nullify
  belongs_to :main, class_name: 'User'
  # always order bans descending by end of ban; duration = -1 ensures perma bans on top
  has_many :bans, -> { order 'duration = -1, created_at + INTERVAL duration DAY' }, dependent: :destroy

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :level, presence: true, inclusion: { in: 1..30 }

  def banned?
    bans.last.active?
  end

  def self.find_or_create(name)
    summoner = Summoner.find_by_name name
    return nil if summoner.nil?

    user = User.find summoner.id rescue nil
    if user
      # update user name from API
      user.name = summoner.name
    else
      user = User.new(id: summoner.id, name: summoner.name, level: summoner.summonerLevel)
    end
    user.save!
    user
  end
end
