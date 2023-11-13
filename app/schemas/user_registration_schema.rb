require 'dry-schema'

UserRegistrationSchema = Dry::Schema.Params do
  required(:user).hash do
    required(:email).filled(:string, format?: /@/)
    required(:password).filled(:string, min_size?: 6)
    required(:name).filled(:string)
  end
end