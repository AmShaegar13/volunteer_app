class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_session, except: [:auth, :verify]

  respond_to :json, :html

  def check_session
    session[:tool_user_id]
    unless session.key?(:tool_user_id) && ToolUser.find_by(id: session[:tool_user_id])
      reset_session
      redirect_to :auth
    end
  end

  def current_user
    return nil unless session.key? :tool_user_id
    @current ||= ToolUser.find_by(id: session[:tool_user_id])
  end
  private :current_user
end
