class User < ActiveRecord::Base
  has_many :smurfs, class_name: 'User', foreign_key: 'main_id'
  belongs_to :main, class_name: 'User'

  has_many :bans
end
