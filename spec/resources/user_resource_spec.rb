require 'rails_helper'

RSpec.describe UserResource do
  describe 'Serialization' do
    it 'serializes attributes' do
      user = create(:user)
      resource = UserResource.new(user, [])
      serialized_json = resource.custom_json

      expect(serialized_json[:data][:attributes][:email]).to eq(user.email)
      expect(serialized_json[:data][:attributes][:name]).to eq(user.name)
    end

    it 'serializes relationships' do
      user = create(:user)
      snippet = create(:snippet, user: user)
      resource = UserResource.new(user, [snippet])
      serialized_json = resource.custom_json

      expect(serialized_json[:data][:relationships][:snippets]).not_to be_empty
    end

    it 'serializes links' do
      user = create(:user)
      resource = UserResource.new(user, [])
      serialized_json = resource.custom_json

      expect(serialized_json[:links][:self]).to eq(Rails.application.routes.url_helpers.user_path(user))
      expect(serialized_json[:data][:relationships][:snippets][:links][:self]).to eq(Rails.application.routes.url_helpers.snippets_path)
    end
  end
end