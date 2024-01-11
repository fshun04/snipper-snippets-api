class SnippetSerializer
  include JSONAPI::Serializer
  attributes :id, :content, :user_id, :created_at, :updated_at
  has_one :user

  def user_id
    current_user.id
  end
end