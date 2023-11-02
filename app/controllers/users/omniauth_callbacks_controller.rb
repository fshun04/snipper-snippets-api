# class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
#   skip_before_action :verify_authenticity_token, only: :google_oauth2

#   def google_oauth2
#     @user = User.from_omniauth(request.env['omniauth.auth'])
#     if @user.persisted?
#       token = @user.generate_jwt_token # Assuming you have a method to generate a JWT token
#       render json: {
#         status: {
#           code: 200,
#           message: 'Logged in successfully.',
#           data: {
#             user: UserSerializer.new(@user).serializable_hash[:data][:attributes],
#             jwt: token
#           }
#         }
#       }, status: :ok
#     else
#       render json: {
#         status: {
#           code: 401,
#           message: 'Login failed.'
#         }
#       }, status: :unauthorized
#     end
#   end
# end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    access_token = request.env["omniauth.auth"]
    if access_token.info.email.present?
      user = User.find_or_create_by(email: access_token.info.email)
      sign_in(:user, user)
      token = Devise::JWT::TestHelpers.auth_headers({}, user)[Devise::JWT::Headers.header_name][0]
      render json: { token: token }
    end
  end
end
