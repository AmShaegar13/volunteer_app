class Ban < ActiveRecord::Base
  ALLOWED_DURATIONS = [1, 3, 7, 14, 0]

  include Yap

  belongs_to :user
  belongs_to :creator, class_name: ToolUser.name, foreign_key: 'creator_id'
  has_many :actions, as: :reference, dependent: :destroy

  scope :common_reasons, -> { select(:reason).group(:reason).order('COUNT(reason) DESC').limit(15) }
  scope :ordered_by_end, -> { order('created_at + INTERVAL duration DAY DESC') }
  scope :with_user_and_creator, -> { includes(:user, :creator) }

  with_options presence: true do |ban|
    ban.validates :duration, inclusion: {
      in: ALLOWED_DURATIONS
    }
    ban.validates :user
    ban.validates :reason
    ban.validates :creator
  end
  validates :link, allow_blank: true, format: {
    with: LINK_REGEXP
  }

  def self.map_name_to_column(name)
    case name
      when 'banned_by' then 'tool_users.name'
      when 'creator' then 'tool_users.name'
      when 'region' then 'users.region'
      when 'summoner' then 'users.name'
    end
  end

  def ends
    created_at + duration.days
  end

  def permanent?
    duration == 0
  end

  def active?
    permanent? || ends > Time.now
  end

  def next_duration
    result = ALLOWED_DURATIONS.at ALLOWED_DURATIONS.index(duration)+1
    result || duration
  end

  def self.propose(user)
    bans = user.bans
    return 1 if bans.empty?
    proposals = bans.map(&:next_duration)
    proposals.include?(0) ? 0 : proposals.max
  end
end
