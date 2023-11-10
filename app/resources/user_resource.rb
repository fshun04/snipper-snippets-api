class UserResource < JSONAPI::Resource
  attributes :email, :name
  has_many :snippets

  def initialize(user)
    @user = user
  end

  def custom_json
    {
      links: {
        self: Rails.application.routes.url_helpers.users_path
      },
      data: {
        type: "users",
        id: @user.id,
        attributes: {
          email: @user.email,
          name: @user.name,
          created_at: @user.created_at,
          updated_at: @user.updated_at
        },
        relationships: {
          snippets: {
            links: {
              self: Rails.application.routes.url_helpers.snippets_path
            },
            data: @user.snippets.map do |snippet|
              {
                type: "snippets",
                id: snippet.id.to_s,
                attributes: {
                  content: snippet.content,
                  created_at: snippet.created_at,
                  updated_at: snippet.updated_at
                }
              }
            end
          }
        }
      }
    }
  end

end

