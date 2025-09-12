class AddCaseInsensitiveUniqueIndexOnTagsName < ActiveRecord::Migration[7.1]
  def up
    remove_index :tags, :name if index_exists?(:tags, :name)
    execute <<~SQL
      CREATE UNIQUE INDEX index_tags_on_lower_name ON tags (LOWER(name));
    SQL
  end

  def down
    execute "DROP INDEX IF EXISTS index_tags_on_lower_name;"
    add_index :tags, :name, unique: true
  end
end

