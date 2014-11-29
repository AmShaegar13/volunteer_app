class Ban < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, class_name: ToolUser.name, foreign_key: 'creator_id'
  has_many :actions, as: :reference, dependent: :destroy

  scope :common_reasons, -> { select(:reason).group(:reason).order('COUNT(reason) DESC').limit(15) }
  scope :ordered_by_end, -> { order('created_at + INTERVAL duration DAY DESC') }

  with_options presence: true do |ban|
    ban.validates :duration, inclusion: {
    in: [1, 3, 7, 14, 0]
    }
    ban.validates :user
    ban.validates :reason
    ban.validates :link, format: {
    with: %r#http://forums\.(na|euw|eune)\.leagueoflegends\.com/board/showthread.php\?[tp]=\d+.*#
    }
    ban.validates :creator
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
end
