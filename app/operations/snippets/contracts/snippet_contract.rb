require 'dry-validation'

module Snippets
  module Contracts
    class SnippetContract < Dry::Validation::Contract
      params do
        required(:snippet).hash do
          required(:content).filled(:string)
        end
      end
    end
  end
end