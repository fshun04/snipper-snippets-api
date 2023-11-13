require 'dry-schema'

SnippetSchema = Dry::Schema.Params do
  required(:snippet).hash do
    required(:content).filled(:string)
  end
end