describe 'User API' do
  path '/snippets' do
    get 'displays the current user\'s snippets' do
      tags 'Snippets'
      security [bearerAuth: {}]
      produces 'application/json'
      document_index_parameters ::Indexes::Snippet

      response '200', 'successful response' do
        run_test!
      end

      response '401', 'active session not found' do
        run_test!
      end
    end

    post 'creates a new snippet for the current user' do
      tags 'Snippets'
      security [bearerAuth: {}]
      consumes 'application/json'
      parameter name: :snippet, in: :body, required: true, schema: {
        type: :object,
        properties: {
          snippet: {
            type: :object,
            properties: {
              content: { type: :string }
            },
            required: [:content]
          }
        },
        required: [:snippet]
      }



      response '201', 'snippet created' do
        let(:valid_snippet) { build(:valid_snippet) }
        run_test!
      end

      response '422', 'invalid snippet' do
        let(:invalid_snippet) { build(:invalid_snippet) }
        run_test!
      end
    end
  end
end