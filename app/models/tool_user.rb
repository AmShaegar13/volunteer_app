class ToolUser < ActiveRecord::Base
  validates :id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
