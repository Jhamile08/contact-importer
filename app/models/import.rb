class Import < ApplicationRecord
  enum :status, { on_hold: 0, processing: 1, finished: 2, failed: 3 }

  belongs_to :user
  has_many :contact_users
  has_many :import_errors
  has_one_attached :file
 after_update_commit :broadcast_update

  private

  def broadcast_update
    # Solo enviamos el Turbo Stream si cambia el status (opcional)
    return unless saved_change_to_status?

    Turbo::StreamsChannel.broadcast_replace_to "imports",
      target: "import_#{id}",
      partial: "imports/import",
      locals: {
        import: self,
        contacts: contact_users.page(1),
        errors: import_errors.page(1)
      }
  end
end
