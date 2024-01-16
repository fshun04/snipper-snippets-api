# require 'rails_helper'

# RSpec.describe Registrations::Contracts::UserRegistrationContract do
#   let(:contract) { described_class.new }

#   describe 'Validation' do
#     context 'with valid input' do
#       let(:valid_user) { build(:valid_user) }

#       it 'is valid' do
#         input = valid_user.attributes.merge(password: 'apple123')
#         result = contract.call(user: input)
#         expect(result).to be_success
#       end
#     end

#     context 'with invalid input' do
#       let(:invalid_user) { build(:invalid_user) }

#       it 'is invalid' do
#         input = invalid_user.attributes.merge(password: 'apple')
#         result = contract.call(user: input)
#         expect(result).not_to be_success
#       end

#       it 'provides detailed error messages' do
#         input = invalid_user.attributes.merge(password: 'apple')
#         result = contract.call(user: input)
#         expect(result.errors[:user][:email]).to include('is in invalid format')
#         expect(result.errors[:user][:password]).to include('size cannot be less than 6')
#         expect(result.errors[:user][:name]).to include('must be filled')
#       end
#     end
#   end
# end