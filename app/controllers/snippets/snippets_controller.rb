class Snippets::SnippetsController < JSONAPI::ResourceController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user!

  def index
    attributes = params.permit(:sort, filter: {}).to_h
    operation = Snippets::Index.call(attributes, current_user)
    if operation.success?
      render json: SnippetSerializer.new(
        operation.result.filtered,
        operation.result.options
      )
    else
      render json: { errors: operation.errors }, status: :unprocessable_entity
    end
  end

  def create
    attributes = params.permit(snippet: [:content]).to_h
    operation = ::Snippets::Create.call(attributes, current_user)
    if operation.success?
      render json: SnippetSerializer.new(operation.result, params: { current_user: current_user })
    else
      render json: { errors: operation.errors }, status: :unprocessable_entity
    end
  end

end
