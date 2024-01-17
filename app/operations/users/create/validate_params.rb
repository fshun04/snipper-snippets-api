module Users
  class Create
    class ValidateParams < Dry::Validation::Contract
      params do
        required(:user).hash do
          required(:email).filled(:string, format?: /\A[^@\s]+@[^@\s]+\z/)
          required(:password).filled(:string, min_size?: 6)
          required(:name).filled(:string)
        end
      end
    end
  end
end
