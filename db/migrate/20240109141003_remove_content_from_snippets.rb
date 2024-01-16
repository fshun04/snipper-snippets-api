class RemoveContentFromSnippets < ActiveRecord::Migration[7.0]
  def change
    remove_column :snippets, :content
  end
end
