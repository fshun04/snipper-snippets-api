# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  def create
    contract = Registrations::Contracts::UserRegistrationContract.new
    operation = contract.call(params.permit(user: {}).to_h)
    if operation.success?
      user = User.new(operation[:user].to_h)
      if user.save
        snippets = user.snippets
        user_resource = UserResource.new(user, snippets)
        render json: user_resource.custom_json, status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: operation.errors.to_h }, status: :unprocessable_entity
    end
  end
end