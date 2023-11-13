require 'rails_helper'

RSpec.describe SnippetResource do
  describe 'Serialization' do
    it 'serializes attributes' do
      user = create(:user)
      snippet = create(:snippet, user: user)
      resource = SnippetResource.new(user, snippet)
      serialized_json = resource.custom_json

      expect(serialized_json[:data].first[:attributes][:content]).to eq(snippet.content)
    end

    it 'serializes relationships' do
      user = create(:user)
      snippet = create(:snippet, user: user)
      resource = SnippetResource.new(user, snippet)
      serialized_json = resource.custom_json

      expect(serialized_json[:relationships][:user][:data]).not_to be_empty
    end

    it 'serializes links' do
      user = create(:user)
      snippet = create(:snippet, user: user)
      resource = SnippetResource.new(user, [snippet])
      serialized_json = resource.custom_json

      expect(serialized_json[:links][:self]).to eq(Rails.application.routes.url_helpers.snippets_path)
    end
  end
end
