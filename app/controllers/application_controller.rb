class ApplicationController < ActionController::API
  private

  def verify_user!
    unless current_user
      return render json: { error: 'You need to choose an username' }
    end
  end

  def current_user
    user_id = request.headers['User-ID']

    User.where(id: user_id).first
  end
end
