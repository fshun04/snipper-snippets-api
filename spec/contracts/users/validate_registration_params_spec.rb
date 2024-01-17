require 'rails_helper'

RSpec.describe Users::Create::ValidateRegistrationParams do
  let(:validate_params) { described_class.new }

  describe 'User registration validation' do
    context 'with valid input' do
      let(:valid_user) { build(:user) }

      it 'is successful' do
        request_params = valid_user.attributes
        request_params['password'] = 'password123'
        result = validate_params.call(user: request_params)
        expect(result).to be_success
      end
    end

    context 'with invalid input' do
      let(:invalid_user) { build(:user) }

      before(:each) do
        invalid_user.email = 'userexample.com'
        invalid_user.name = ''
      end

      it 'is unsuccessful' do
        request_params = invalid_user.attributes
        request_params['password'] = 'short'
        result = validate_params.call(user: request_params)
        expect(result).not_to be_success
      end

      it 'provides detailed error messages' do
        request_params = invalid_user.attributes
        request_params['password'] = 'short'
        result = validate_params.call(user: request_params)
        expect(result.errors[:user][:email]).to include('is in invalid format')
        expect(result.errors[:user][:password]).to include('size cannot be less than 6')
        expect(result.errors[:user][:name]).to include('must be filled')
      end
    end
  end
end