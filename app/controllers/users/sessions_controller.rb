class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    attributes = params.permit(user: [:email, :password]).to_h
    result = Users::Create::ValidateSessionParams.new.call(attributes)
    if result.success?
      user = User.from_internal_login(
        attributes.dig(:user, :email),
        attributes.dig(:user, :password)
      )
      if user
        sign_in(user)
        render json: UserSerializer.new(user)
      else
        render json: { errors: { authentication: ['Invalid email or password'] } }, status: :unauthorized
      end
    else
      render json: { errors: result.errors.to_h }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    Rails.logger.debug "Headers: #{request.headers.inspect}"
    if request.headers['Authorization'].present?
      jwt_token = request.headers['Authorization'].split(' ')&.last
      Rails.logger.debug "JWT Token: #{jwt_token}"
      begin
        jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.devise_jwt_secret_key!).first
        Rails.logger.debug "Decoded JWT Payload: #{jwt_payload}"
        current_user = User.find(jwt_payload['sub'])
      rescue JWT::DecodeError => e
        Rails.logger.error "JWT Decode Error: #{e.message}"
      end
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
