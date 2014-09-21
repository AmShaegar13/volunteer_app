class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_session, except: [:auth, :verify]

  def check_session
    session[:tool_user_id]
    unless session.key? :tool_user_id
      redirect_to :auth
    end
  end
end
