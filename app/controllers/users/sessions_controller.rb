# frozen_string_literal: true

# class Users::SessionsController < Devise::SessionsController
#   include RackSessionsFix
#   respond_to :json

#   def respond_with(current_user, _opts = {})

#     if request.env['omniauth.auth']
#       # User logged in via Google OAuth
#       user = User.from_omniauth(request.env['omniauth.auth'])
#     else
#       # User did not log in via Google OAuth
#       user = User.from_internal_login(params[:user][:email], params[:user][:password])
#     end

#     if user && user.valid_password?(params[:user][:password])
#       sign_in user
#       render json: {
#         status: {
#           code: 200,
#           message: 'Logged in successfully.',
#           data: { user: UserSerializer.new(user).serializable_hash[:data][:attributes] }
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

#   def respond_to_on_destroy
#     if request.headers['Authorization'].present?
#       jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
#       current_user = User.find(jwt_payload['sub'])
#     end

#     if current_user
#       sign_out(current_user)
#       render json: {
#         status: 200,
#         message: 'Logged out successfully.'
#       }, status: :ok
#     else
#       render json: {
#         status: 401,
#         message: "Couldn't find an active session."
#       }, status: :unauthorized
#     end
#   end
# end

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    puts "Request for create action: #{request.inspect}"
    user = User.from_internal_login(params[:user][:email], params[:user][:password])
    if user
      sign_in(user)
      render json: { message: 'Logged in successfully', user: user }
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      sign_out(current_user)
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
