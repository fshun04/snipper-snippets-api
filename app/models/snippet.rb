class Snippet < ActiveRecord::Base
  include Filterable
  include Sortable

  belongs_to :user

  attr_encrypted :content, key: Rails.application.credentials.attr_encrypted_key

  def decrypt_and_downcase
    { id: self.id, content: self.content.downcase }
  end

  def decrypt_and_search(val)
    decrypted_content = self.content
    decrypted_content.include?(val)
  end

end
