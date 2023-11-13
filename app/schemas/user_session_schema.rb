require 'dry-schema'

UserSessionSchema = Dry::Schema.Params do
  required(:user).hash do
    required(:email).filled(:string, format?: /@/)
    required(:password).filled(:string, min_size?: 6)
  end
end