class Action < ActiveRecord::Base
  belongs_to :tool_user
  belongs_to :reference, polymorphic: true

  scope :creation, -> { where(action: 'create').first }

  validates :tool_user, presence: true
  validates :action, presence: true
  validates :reference, presence: true
end
