require 'rails_helper'

describe User do
  subject { create(:user) }

  describe 'associations' do
    it { should have_many(:snippets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:name) }
  end
end