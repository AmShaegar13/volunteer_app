class Ban < ActiveRecord::Base
  belongs_to :user

  validates :duration, presence: true
  validates :user, presence: true
  validates :reason, presence: true
  validates :link, presence: true, format: {
      with: %r#http://forums\.(na|euw|eune)\.leagueoflegends\.com/board/showthread.php\?[tp]=\d+.*#
  }

  def end
    created_at + duration.days
  end
end
