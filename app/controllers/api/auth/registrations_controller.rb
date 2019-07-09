module Api
  module Auth
    class Api::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
      private

      # :passwordを追加できるようにpravateメソッドに修正を加える
      def sign_up_params
        params.permit(:name, :email, :password, :password_confirmation)
      end

      def account_update_params
        params.permit(:name, :email, :password)
      end
    end
  end
end
