class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id'
  belongs_to :main, class_name: 'User'
  has_many :bans, -> { order 'created_at DESC' }

  validates :name, presence: true

  def self.ordered_by_end_of_ban(limit = 15)
    Ban.order('created_at + INTERVAL duration DAY DESC').limit(limit).map { |ban| ban.user }
  end
end
