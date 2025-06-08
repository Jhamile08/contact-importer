class Import < ApplicationRecord
  # Enum for status with friendly names (on hold, processing, etc.)
  enum :status, { on_hold: 0, processing: 1, finished: 2, failed: 3 }

  # Associations
  belongs_to :user
  has_many :contact_users
  has_many :import_errors
  has_one_attached :file  # CSV file uploaded

  # When the record updates, trigger a Turbo broadcast
  after_update_commit :broadcast_update
 
  # Validation to make sure a file is attached
  validates :file, presence: { message: "must be attached" }

  private

  # This method sends a Turbo Stream update to the browser
  # It only runs if the status has changed
  def broadcast_update
    return unless saved_change_to_status?

    Turbo::StreamsChannel.broadcast_replace_to "imports",
      target: "import_#{id}",               # DOM ID of the element to replace
      partial: "imports/import",           # Partial view to render
      locals: {
        import: self,                      # Current import object
        contacts: contact_users.page(1),   # Paginated contacts
        errors: import_errors.page(1)      # Paginated errors
      }
  end
end
