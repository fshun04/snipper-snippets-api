# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  def create
    input = UserRegistrationSchema.call(params.permit(user: {}).to_h)
    if input.success?
      user = User.new(input[:user].to_h)
      if user.save
        snippets = user.snippets
        user_resource = UserResource.new(user, snippets)
        render json: user_resource.custom_json, status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: input.errors.to_h }, status: :unprocessable_entity
    end
  end
end