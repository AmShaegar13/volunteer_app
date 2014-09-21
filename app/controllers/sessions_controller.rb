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
      session[:tool_user_id] = auth.user[:id]
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
end
