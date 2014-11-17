class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_session, except: [:auth, :verify]

  respond_to :json, :html

  def default_url_options
    if request.headers['X-Forwarded-Proto'] == 'https'
      { protocol: 'https://' }
    else
      {}
    end
  end

  def check_session
    if current_user == ToolUser.default_user
      reset_session
      redirect_to :auth
    end
  end

  def current_user
    return ToolUser.default_user unless session[:tool_user_id]
    @current ||= ToolUser.find_by(id: session[:tool_user_id])
  end
  private :current_user

  # TODO find a better place for this
  def find_or_create_user(user_params)
    user = User.find_or_create_by!(user_params.slice(:id, :name))
    Action.create!(tool_user: current_user, action: 'create', reference: user) if user.new_record?

    user
  end
end
