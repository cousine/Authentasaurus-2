class ValidationsController < ApplicationController
	def index
		respond_to do |format|
			format.html {
				validation = Validation.find_by_validation_code(params[:vcode])
				if validation
					validation.user.active = true
					validation.destroy
					flash.now[:notice] = "Account activated successfully"
					redirect_to login_url
				else
					flash.now[:notice] = "Validation failed, check your validation code and try again"
				end
			}
		end
	end
end