class Ban < ActiveRecord::Base
  belongs_to :user

  validates :duration, presence: true, inclusion: {
      in: [1, 3, 7, 14, -1]
  }
  validates :user, presence: true
  validates :reason, presence: true
  validates :link, presence: true, format: {
      with: %r#http://forums\.(na|euw|eune)\.leagueoflegends\.com/board/showthread.php\?[tp]=\d+.*#
  }

  def ends
    created_at + duration.days
  end

  def active?
    ends > Time.now
  end

  def permanent?
    duration == -1
  end

  def self.ordered_by_end
    Ban.order('created_at + INTERVAL duration DAY DESC')
  end
end
