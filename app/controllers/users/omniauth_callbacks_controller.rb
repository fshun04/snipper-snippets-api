class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        render json: { message: 'Successfully authenticated via Google OAuth2', user: @user }, status: :ok
      else
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
        render json: { error: @user.errors.full_messages.join("\n") }, status: :unprocessable_entity
      end
  end

  def failure
    render json: { error: 'There was an error while trying to authenticate you...' }, status: :forbidden
  end
end