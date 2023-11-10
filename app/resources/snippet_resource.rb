class SnippetResource < JSONAPI::Resource
  attributes :content
  has_one :user

  def initialize(snippets, current_user)
    @snippets = snippets
    @current_user = current_user
  end

  def custom_json
    {
      links: {
        self: Rails.application.routes.url_helpers.snippets_path
      },
      data: @snippets.map do |snippet|
        {
          type: "snippets",
          id: snippet.id.to_s,
          attributes: {
            content: @snippet.content,
            created_at: @snippet.created_at,
            updated_at: @snippet.updated_at
          },
          relationships: {
            user: {
              links: {
                self: Rails.application.routes.url_helpers.user_path(@current_user)
              },
              data: {
                type: "users",
                id: @current_user.id.to_s,
                attributes: {
                  email: @current_user.email,
                  name: @current_user.name
                }
              }
            }
          }
        }
      end
    }
  end
end
