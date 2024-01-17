require 'rails_helper'

RSpec.describe SnippetsController, type: :request do
  before(:each) do
    DatabaseCleaner.clean
    FactoryBot.rewind_sequences
  end

  describe 'GET /snippets' do
    context 'when displaying the user\'s snippets (sorting/filtering disabled)' do
      let(:user) { create(:user) }

      let!(:first_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }
      let!(:second_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }
      let!(:third_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }

      before(:each) do
        sign_in user
        get '/snippets'
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct number of snippets' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data'].count).to eq(3)
      end

      it 'returns snippets with the correct content' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data'][0]['attributes']['content']).to eq(third_snippet.content)
        expect(parsed_response['data'][1]['attributes']['content']).to eq(second_snippet.content)
        expect(parsed_response['data'][2]['attributes']['content']).to eq(first_snippet.content)
      end
    end

    context 'when displaying the user\'s snippets (sorting enabled)' do

      let(:user) { create(:user) }

      let!(:first_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }
      let!(:second_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }
      let!(:third_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }

      before(:each) do
        sign_in user
        get '/snippets', params: { sort: 'content' }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct number of snippets' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data'].count).to eq(3)
      end

      it 'returns snippets sorted by content' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data'][0]['attributes']['content']).to eq(second_snippet.content)
        expect(parsed_response['data'][1]['attributes']['content']).to eq(first_snippet.content)
        expect(parsed_response['data'][2]['attributes']['content']).to eq(third_snippet.content)
      end
    end

    context 'when displaying the user\'s snippets (filtering enabled)' do
      let(:user) { create(:user) }

      let!(:first_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }
      let!(:second_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }
      let!(:third_snippet) { create(:snippet, user: user, content: generate(:content_sequence)) }

      before(:each) do
        sign_in user
        get '/snippets', params: { filter: { content: { contains: 'p' } } }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(200)
      end

      it 'returns the correct number of snippets' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data'].count).to eq(2)
      end

      it 'returns snippets with the correct content' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data'][0]['attributes']['content']).to eq(second_snippet.content)
        expect(parsed_response['data'][1]['attributes']['content']).to eq(first_snippet.content)
      end
    end
  end
end