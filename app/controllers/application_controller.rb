class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user! 
  protect_from_forgery
  
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized



  def after_sign_in_path_for(resource)
    home_home_path # Replace with the actual named route of 'home/home'
  end




  private
  def user_not_authorized #pundit
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
  
end
 