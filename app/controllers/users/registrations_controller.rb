# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  # def create
  #   # replace with validate_params
  #   contract = Contracts::Users::UserRegistrationContract.new
  #   operation = contract.call(params.permit(user: {}).to_h)
  #   if operation.success?
  #     user = User.new(operation[:user].to_h)
  #     if user.save
  #       snippets = user.snippets
  #       user_resource = UserResource.new(user, snippets)
  #       render json: user_resource.custom_json, status: :created
  #     else
  #       render json: { errors: user.errors }, status: :unprocessable_entity
  #     end
  #   else
  #     render json: { errors: operation.errors.to_h }, status: :unprocessable_entity
  #   end
  # end

  def create
    attributes = params.permit(user: [:email, :password, :name]).to_h
    operation = ::Users::Create.call(attributes)
    if operation.success?
      render json: UserSerializer.new(operation.result)
    else
      render json: { errors: operation.errors }, status: :unprocessable_entity
    end
  end
end