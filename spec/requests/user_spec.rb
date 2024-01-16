require 'swagger_helper'

describe 'User API' do
  path '/signup' do
    post 'registers a new user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string, minLength: 6 },
              name: { type: :string }
            },
            required: [:email, :password, :name]
          }
        }
      }

      response '201', 'user registered' do
        let(:valid_user) { build(:valid_user) }
        run_test!
      end

      response '422', 'invalid user' do
        let(:invalid_user) { build(:invalid_user) }
        run_test!
      end
    end
  end

  path '/login' do
    post 'logs a user in' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string, minLength: 6 }
            },
            required: [:email, :password]
          }
        }
      }

      response '201', 'user logged in' do
        let(:valid_user) { build(:valid_user) }
        run_test!
      end

      response '422', 'invalid user' do
        let(:invalid_user) { build(:invalid_user) }
        run_test!
      end
    end
  end

  path '/logout' do
    delete 'logs a user out' do
      tags 'Users'
      security [bearerAuth: {}]
      produces 'application/json'

      response '200', 'user logged out' do
        run_test!
      end

      response '401', 'active session not found' do
        run_test!
      end
    end
  end
end