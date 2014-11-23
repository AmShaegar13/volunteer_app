class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id', dependent: :nullify
  belongs_to :main, class_name: 'User'
  # always order bans descending by end of ban; duration = 0 ensures perma bans on top
  has_many :bans, -> { order 'duration = 0, created_at + INTERVAL duration DAY' }, dependent: :destroy
  has_many :actions, as: :reference, dependent: :destroy

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :level, presence: true, inclusion: { in: 1..30 }
  validates :region, presence: true, inclusion: { in: %w(na euw eune) }

  def banned?
    !bans.empty? && bans.last.active?
  end

  def self.find_or_create_by!(params = {})
    return User.find params[:id] if params.key? :id
    raise ArgumentError, 'No valid parameter found. Valid parameters are [:id, :name]' unless params.key? :name

    summoner = Summoner.find_by! name: params[:name], region: params[:region]

    user = find_or_create_by id: summoner.id
    user.name = summoner.name
    user.level = summoner.summonerLevel
    user.save!

    user
  rescue ActiveResource::ResourceNotFound
    raise VolunteerApp::SummonerNotFound, "Summoner '#{params[:name]}' does not exist."
  end

  def self.search(name)
    return [] if name.blank?
    User.where('LOWER(name) LIKE LOWER(?)', "%#{name}%")
  end
end
