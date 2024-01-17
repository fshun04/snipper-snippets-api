# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

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