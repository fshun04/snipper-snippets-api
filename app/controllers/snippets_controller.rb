class SnippetsController < JSONAPI::ResourceController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    snippets = current_user.snippets
    snippet_resource = SnippetResource.new(snippets, current_user)
    render json: snippet_resource.custom_json, status: :ok
  end

  def show
    user = User.find(params[:user_id])
    snippet = user.snippets.find(params[:id])
    render json: SnippetResource.new(snippet), status: :ok
  end

  def create
    snippet = current_user.snippets.new(snippet_params)
    if snippet.save
      render json: snippet, status: :created
    else
      render json: { errors: snippet.errors }, status: :unprocessable_entity
    end
  end

  def update
    snippet = current_user.snippets.find(params[:id])
    if snippet.update(snippet_params)
      render json: SnippetResource.new(snippet), status: :ok
    else
      render json: { errors: snippet.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    snippet = current_user.snippets.find(params[:id])
    snippet.destroy
    head :no_content
  end

  def snippet_params
    params.require(:snippet).permit(:content)
  end
end
