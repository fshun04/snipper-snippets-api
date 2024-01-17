require 'rails_helper'

RSpec.describe Snippets::Create::ValidateParams do
  let(:validate_params) { described_class.new }

  describe 'Snippet creation validation' do
    context 'with valid input' do
      let(:valid_snippet) { build(:first_snippet) }

      it 'is successful' do
        request_params = valid_snippet.attributes
        result = validate_params.call(snippet: request_params)
        expect(result).to be_success
      end
    end

    context 'with invalid input' do
      let(:invalid_snippet) { build(:first_snippet) }

      before(:each) do
        invalid_snippet.content = ''
      end

      it 'is unsuccessful' do
        request_params = invalid_snippet.attributes
        result = validate_params.call(snippet: request_params)
        expect(result).not_to be_success
      end

      it 'provides detailed error messages' do
        request_params = invalid_snippet.attributes
        result = validate_params.call(snippet: request_params)
        expect(result.errors[:snippet][:content]).to include('must be filled')
      end
    end
  end
end