class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id', dependent: :nullify
  belongs_to :main, class_name: 'User'
  # always order bans descending by end of ban; duration = 0 ensures perma bans on top
  has_many :bans, -> { order 'duration = 0, created_at + INTERVAL duration DAY' }, dependent: :destroy
  has_many :actions, as: :reference, dependent: :destroy

  scope :search, -> name { where('LOWER(name) LIKE LOWER(?) OR name IN (?)', "%#{name}%", Summoner.brute_force_encoding(name)) }

  with_options presence: true do |user|
    user.validates :name
    user.validates :level, inclusion: { in: 1..30 }
    user.validates :region, inclusion: { in: %w[ na euw eune ] }
    user.validates :summoner_id
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

  def self.find_or_create_by!(params = {})
    return User.find params[:id] if params.key? :id
    raise ArgumentError, 'No valid parameter found. Valid parameters are [:id, :name]' unless params.key? :name

    extract_region_from_name! params
    summoner = Summoner.find_by! name: params[:name], region: params[:region]

    user = find_or_create_by summoner_id: summoner.id, region: params[:region]
    user.name = summoner.name
    user.level = summoner.summonerLevel
    user.save!

    user
  end

  def self.find_by(opts)
    extract_region_from_name! opts
    super opts
  end

  def self.find_by!(opts)
    extract_region_from_name! opts
    super opts
  end

  def self.extract_region_from_name!(opts)
    if opts.key? :name
      if opts[:name].match(/\s\(.+\)/)
        region = opts[:name].slice!(/\s?\(.+\)/)[/\((.+)\)/, 1]
        if opts.key?(:region) && opts[:region] != region
          raise ArgumentError, 'Cannot extract region from name. Region already set: ' + opts.inspect
        end
        opts[:region] = region
      end
    end

    opts
  end
  private_class_method :extract_region_from_name!

  def self.search_name(name)
    search(name).map(&:name_with_region)
  end

  def self.search_name_with_proposal(name)
    search(name).includes(:bans).map do |user|
      { name: user.name_with_region, proposal: Ban.propose(user) }
    end
  end

  def name_with_region
    '%s (%s)' % [name, region]
  end
end
