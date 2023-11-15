class Users::SessionsController < Devise::SessionsController

  include RackSessionsFix
  respond_to :json

  def create
    contract = Sessions::Contracts::UserSessionContract.new
    operation = contract.call(params.permit(user: {}).to_h)
    if operation.success?
      user = User.from_internal_login(operation[:user][:email], operation[:user][:password])
      if user
        sign_in(user)
        snippets = current_user.snippets
        user_resource = UserResource.new(current_user, snippets)
        render json: user_resource.custom_json, status: :created
      else
        render json: { errors: [{ title: 'Invalid email or password' }] }, status: :unauthorized
      end
    else
      render json: { errors: operation.errors.to_h }, status: :unprocessable_entity
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
