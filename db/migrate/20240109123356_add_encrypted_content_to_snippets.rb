class AddEncryptedContentToSnippets < ActiveRecord::Migration[7.0]
  def change
    add_column :snippets, :encrypted_content, :string
    add_column :snippets, :encrypted_content_iv, :string
  end
end
