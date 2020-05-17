class ApplicationController < ActionController::API
  private

  def verify_user!
    haed :unauthorized unless current_user
  end

  def current_user
    user_id = request.headers['User-ID']

    User.find(user_id)
  end
end
