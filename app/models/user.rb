class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id', dependent: :nullify
  belongs_to :main, class_name: 'User'
  has_many :bans, -> { order 'created_at + INTERVAL duration DAY' }, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def banned?
    bans.last.ends > Time.now
  end
end
