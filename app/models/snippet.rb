class Snippet < ActiveRecord::Base
  include Filterable
  include Sortable

  belongs_to :user

  attr_encrypted :content, key: Rails.application.credentials.attr_encrypted_key

  private

  def decrypt_and_search(val)
    decrypted_content = self.content
    decrypted_content.include?(val)
  end

end
