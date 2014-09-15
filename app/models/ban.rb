class Ban < ActiveRecord::Base
  belongs_to :user

  validates :duration, presence: true
  validates :user, presence: true
  validates :reason, presence: true
  validates :link, presence: true
end
