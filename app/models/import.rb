class Import < ApplicationRecord
  belongs_to :user
  has_many :contact_users
  has_many :import_errors
  has_one_attached :file

  enum status: {
    on_hold: 0,
    processing: 1,
    failed: 2,
    finished: 3
  }
end


