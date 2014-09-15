class UsersController < ApplicationController
  def index
    @users = User.ordered_by_end_of_ban
  end
end
