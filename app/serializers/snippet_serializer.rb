class SnippetSerializer
  include JSONAPI::Serializer
  attributes :id, :content, :user_id, :created_at, :updated_at
  has_one :user
end