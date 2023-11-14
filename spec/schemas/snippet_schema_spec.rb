require 'rails_helper'

RSpec.describe SnippetSchema do
  describe 'Validation' do
    context 'with valid input' do
      let(:valid_snippet) { build(:valid_snippet) }

      it 'is valid' do
        input = valid_snippet.attributes
        result = described_class.call(snippet: input)
        expect(result).to be_success
      end
    end

    context 'with invalid input' do
      let(:invalid_snippet) { build(:invalid_snippet) }

      it 'is invalid' do
        input = invalid_snippet.attributes
        result = described_class.call(snippet: input)
        expect(result).not_to be_success
      end

      it 'provides detailed error messages' do
        input = invalid_snippet.attributes
        result = described_class.call(snippet: input)
        expect(result.errors[:snippet][:content]).to include('must be filled')
      end
    end
  end
end