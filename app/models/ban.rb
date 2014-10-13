class Ban < ActiveRecord::Base
  belongs_to :user
  has_many :actions, as: :reference, dependent: :destroy

  validates :duration, presence: true, inclusion: {
      in: [1, 3, 7, 14, 0]
  }
  validates :user, presence: true
  validates :reason, presence: true
  validates :link, format: {
      with: %r#http://forums\.(na|euw|eune)\.leagueoflegends\.com/board/showthread.php\?[tp]=\d+.*#
  }

  def ends
    created_at + duration.days
  end

  def permanent?
    duration == 0
  end

  def active?
    permanent? || ends > Time.now
  end

  def creator
    actions.where(action: 'create').first.tool_user
  end

  def self.ordered_by_end
    Ban.all.order('created_at + INTERVAL duration DAY DESC')
  end
end
