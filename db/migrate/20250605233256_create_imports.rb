class CreateImports < ActiveRecord::Migration[7.2]
  def change
    create_table :imports do |t|
      t.string :file
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
