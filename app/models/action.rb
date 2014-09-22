class Action < ActiveRecord::Base
  belongs_to :tool_user
  belongs_to :reference, polymorphic: true

  validates :tool_user, presence: true
  validates :action, presence: true
  validates :reference, presence: true
end
