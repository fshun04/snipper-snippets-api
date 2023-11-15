class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :content
  has_one :user
end
