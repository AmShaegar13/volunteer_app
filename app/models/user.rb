class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id', dependent: :nullify
  belongs_to :main, class_name: 'User'
  # always order bans descending by end of ban; duration = -1 ensures perma bans on top
  has_many :bans, -> { order 'duration = -1, created_at + INTERVAL duration DAY' }, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def banned?
    bans.last.active?
  end

  def self.find_or_create(id, name)
    if name.blank?
      return User.find id
    end

    summoner = Summoner.find_by_name(name)
    return nil if summoner.nil?

    user = User.find summoner.id rescue nil
    User.new id: summoner.id, name: summoner.name if user.nil?
  end
end
