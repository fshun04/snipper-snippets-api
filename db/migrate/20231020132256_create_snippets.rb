class CreateSnippets < ActiveRecord::Migration[7.0]
  def change
    create_table :snippets do |t|
      t.string :content
      t.references :user, index: true
      t.timestamps
    end
  end
end
