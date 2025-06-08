class AddColumnMappingToImports < ActiveRecord::Migration[7.2]
  def change
    add_column :imports, :column_mapping, :json
  end
end
