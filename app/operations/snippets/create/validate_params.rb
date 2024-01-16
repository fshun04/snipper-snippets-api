module Snippets
  class Create
    class ValidateParams < Dry::Validation::Contract
      params do
        required(:snippet).hash do
          required(:content).filled(:string)
        end
      end
    end
  end
end
