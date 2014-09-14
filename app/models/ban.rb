class Ban < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :duration, presence: true
  validates :user, presence: true
end
