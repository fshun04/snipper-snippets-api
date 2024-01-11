class RemoveContentFromSnippets < ActiveRecord::Migration[7.0]
  def change
    remove_column :snippets, :content
    remove_column :snippets, :encrypted_content_salt
  end
end
