class ToolUser < ActiveRecord::Base
  has_many :actions

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  cattr_accessor :current

  def self.default_user
    find_by(id: -1)
  end
end
