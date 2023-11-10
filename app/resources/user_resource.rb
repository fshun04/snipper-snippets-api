class UserResource < JSONAPI::Resource
  attributes :email, :name
  has_many :snippets

  def initialize(current_user, snippets)
    @current_user = current_user
    @snippets = snippets
  end

  def custom_json
    {
      data: {
        type: "users",
        id: @current_user.id,
        attributes: {
          email: @current_user.email,
          name: @current_user.name,
        },
        relationships: {
          snippets: {
            links: {
              self: Rails.application.routes.url_helpers.snippets_path
            },
            data: @current_user.snippets.map do |snippet|
              {
                type: "snippets",
                id: snippet.id.to_s,
                attributes: {
                  content: snippet.content
                }
              }
            end
          }
        }
      },
      links: {
        self: Rails.application.routes.url_helpers.user_path(@current_user)
      }
    }
  end

end

