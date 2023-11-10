# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  def create
    user = User.new(sign_up_params)
    if user.save
      snippets = user.snippets
      user_resource = UserResource.new(user, snippets)
      render json: user_resource.custom_json, status: :ok, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :name)
  end
end

