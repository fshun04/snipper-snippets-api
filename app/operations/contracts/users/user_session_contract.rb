require 'dry-validation'

module Contracts
  module Users
    class UserSessionContract < Dry::Validation::Contract
      params do
        required(:user).hash do
          required(:email).filled(:string, format?: /@/)
          required(:password).filled(:string, min_size?: 6)
        end
      end
    end
  end
end
