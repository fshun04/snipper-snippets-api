module Snippets
  class SnippetsController < ApplicationController

    before_action :authenticate_user!

    def index
      snippets = current_user.snippets.all
      render json: snippets
    end

    def show
      user = User.find(params[:user_id])
      snippet = user.snippets.find(params[:id])
      render json: snippet
    end

    def create
      snippet = current_user.snippets.new(snippet_params)
      if snippet.save
        render json: snippet, status: :created
      else
        render json: snippet.errors, status: :unprocessable_entity
      end
    end

    def update
      snippet = current_user.snippets.find(params[:id])
      if snippet.update(snippet_params)
        render json: snippet
      else
        render json: snippet.errors, status: :unprocessable_entity
      end
    end

    def destroy
      snippet = current_user.snippets.find(params[:id])
      snippet.destroy
      head :no_content
    end

    private

    def snippet_params
      params.require(:snippet).permit(:content)
    end
  end
end
