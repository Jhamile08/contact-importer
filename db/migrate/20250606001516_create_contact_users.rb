class CreateContactUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :contact_users do |t|
      t.string :name
      t.date :dob
      t.string :phone
      t.string :address
      t.string :email
      t.string :encrypted_cc
      t.string :cc_network
      t.references :user, null: false, foreign_key: true
      t.references :import, null: false, foreign_key: true

      t.timestamps
    end
  end
end
