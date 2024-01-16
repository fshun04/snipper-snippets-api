module Contracts
  module Users
    class UserRegistrationContract < Dry::Validation::Contract
      params do
        required(:user).schema do
          required(:email).filled(:string, format?: /\A[^@\s]+@[^@\s]+\z/)
          required(:password).filled(:string, min_size?: 6)
          required(:name).filled(:string)
        end
      end
    end
  end
end