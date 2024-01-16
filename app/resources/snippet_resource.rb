class SnippetResource < JSONAPI::Resource
  attributes :content
  has_one :user

  def initialize(current_user, snippets)
    @current_user = current_user
    @snippets = Array(snippets)
  end

  def custom_json
    {
      links: {
        self: Rails.application.routes.url_helpers.snippets_path
      },
      data: @snippets.map do |snippet|
        {
          type: "snippets",
          id: snippet.id,
          attributes: {
            content: snippet.content
          },
          links: {
            self: Rails.application.routes.url_helpers.snippet_path(snippet.id)
          }
        }
      end,
      relationships: {
        user: {
          data: {
            type: "users",
            id: @current_user.id,
            attributes: {
              email: @current_user.email,
              name: @current_user.name
            }
          },
          links: {
            self: Rails.application.routes.url_helpers.user_path(@current_user)
          }
        }
      }
    }
  end

end