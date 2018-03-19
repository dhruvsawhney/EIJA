class RegistrationsController < Devise::RegistrationsController
    include Accessible

    private

    def sign_up_params
        params.require(:user).permit(:user_name, :major, :grad_year, :enrolled, :email, :password, :password_confirmation)
    end

    def account_update_params
        params.require(:user).permit(:user_name, :major, :grad_year, :enrolled, :email, :password, :password_confirmation, :current_password)
    end
end
