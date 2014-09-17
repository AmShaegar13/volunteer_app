class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id'
  belongs_to :main, class_name: 'User'
  has_many :bans, -> { order 'created_at + INTERVAL duration DAY' }

  validates :name, presence: true

  def banned?
    bans.last.end > Time.now
  end
end
