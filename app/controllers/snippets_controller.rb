class SnippetsController < JSONAPI::ResourceController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    snippets = current_user.snippets
    snippet_resource = SnippetResource.new(current_user, snippets)
    render json: snippet_resource.custom_json, status: :ok
  end

  def show
    snippet = current_user.snippets.find(params[:id])
    snippet_resource = SnippetResource.new(current_user, snippet)
    render json: snippet_resource.custom_json, status: :ok
  end

  def create
    input = SnippetSchema.call(params.permit(snippet: {}).to_h)
    if input.success?
      snippet = current_user.snippets.new(input[:snippet].to_h)
      if snippet.save
        snippet_resource = SnippetResource.new(current_user, snippet)
        render json: snippet, status: :created
      else
        render json: { errors: snippet.errors }, status: :unprocessable_entity
      end
    else
      render json: { errors: input.errors.to_h }, status: :unprocessable_entity
    end
  end
end
