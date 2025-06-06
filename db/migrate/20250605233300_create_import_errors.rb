class CreateImportErrors < ActiveRecord::Migration[7.2]
  def change
    create_table :import_errors do |t|
      t.json :contact_data
      t.string :error_message
      t.references :import, null: false, foreign_key: true

      t.timestamps
    end
  end
end
