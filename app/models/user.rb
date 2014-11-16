class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id', dependent: :nullify
  belongs_to :main, class_name: 'User'
  # always order bans descending by end of ban; duration = 0 ensures perma bans on top
  has_many :bans, -> { order 'duration = 0, created_at + INTERVAL duration DAY' }, dependent: :destroy
  has_many :actions, as: :reference, dependent: :destroy

  with_options presence: true do |user|
    user.validates :id, uniqueness: true
    user.validates :name, uniqueness: true
    user.validates :level, inclusion: { in: 1..30 }
    user.validates :region, inclusion: { in: %w[ na euw eune ] }
  end
  validate :region_fits_main
  validates_associated :smurfs

  def region_fits_main
    unless main.nil? || main.region == region
      errors.add(:region, 'must match main\'s region')
    end
  end

  def banned?
    !bans.empty? && bans.last.active?
  end

  def self.find_or_create_by(params = {})
    return User.find params[:id] if params.key? :id
    raise ArgumentError, 'No valid parameter found. Valid parameters are [:id, :name]' unless params.key? :name

    summoner = Summoner.find_by_name params[:name] rescue nil
    return nil if summoner.nil?

    user = super id: summoner.id
    user.name = summoner.name
    user.level = summoner.summonerLevel

    user
  end

  def self.search(name)
    return [] if name.blank?
    User.where('LOWER(name) LIKE LOWER(?)', "%#{name}%")
  end
end
