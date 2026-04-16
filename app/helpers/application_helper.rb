module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def check_state_badge(state)
    case state
    when "created", "cloning", "checking"
      "warning"
    when "finished"
      "success"
    when "failed"
      "danger"
    else
      "secondary"
    end
  end
end
