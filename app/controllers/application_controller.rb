class ApplicationController < ActionController::Base

	protected

	def configure_permitted_parameters
    	devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    		user_params.permit(:name,:nickname)
        end
  	end

	def after_sign_in_path_for(resource)
		user_url(resource)
	end

end
