class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :content
end
