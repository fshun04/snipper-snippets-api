module Users
  class Create
    class ValidateSessionParams < Dry::Validation::Contract
      params do
        required(:user).hash do
          required(:email).filled(:string)
          required(:password).filled(:string)
        end
      end
    end
  end
end
