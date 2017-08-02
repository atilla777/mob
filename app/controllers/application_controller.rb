class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        if user_signed_in?
          format.html { redirect_back(fallback_location: root_path, notice: exception.message) }
        else
          format.html { redirect_to new_user_session_path, notice: exception.message }
        end
      end
    end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :description])
  end
end
