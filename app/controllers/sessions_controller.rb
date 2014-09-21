class SessionsController < ApplicationController
  def auth
  end

  def logout
    reset_session
    redirect_to :root
  end

  def verify
    credentials = params.require(:auth).permit(:login, :password)
    auth = Authentication.new credentials
    if auth.success? && auth.user[:volunteer]
      authenticate auth.user
    else
      reset_session
      if auth.success?
        flash[:error] = 'Permission denied.'
      else
        flash[:error] = 'Login failed: %s (%d)' % [auth.error, auth.code]
        flash[:carry] = credentials['login']
      end
    end
    redirect_to :root
  end

  def authenticate(user)
    session[:tool_user_id] = user[:id]

    tool_user = ToolUser.find_by_id(user[:id]) || ToolUser.new(id: user[:id])
    tool_user.name = user[:name]
    tool_user.save!
  end
  private :authenticate
end
