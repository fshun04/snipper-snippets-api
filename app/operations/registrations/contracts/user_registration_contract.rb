require 'dry-validation'

module Registrations
  module Contracts
    class UserRegistrationContract < Dry::Validation::Contract
      params do
        required(:user).hash do
          required(:email).filled(:string, format?: /@/)
          required(:password).filled(:string, min_size?: 6)
          required(:name).filled(:string)
        end
      end
    end
  end
end