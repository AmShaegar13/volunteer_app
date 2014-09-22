class ToolUser < ActiveRecord::Base
  has_many :actions

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
