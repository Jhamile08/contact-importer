require 'csv'

class ProcessCsvJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    import = Import.find(import_id)
    import.processing!

    file = import.file.download
    csv = CSV.parse(file, headers: true)

    success = 0

    csv.each do |row|
      begin
        ContactUser.create_from_csv(row.to_h, import.user, import)
        success += 1
      rescue => e
        # Ya se registra error dentro del modelo
        next
      end
    end

    if success > 0
      import.finished!
    else
      import.failed!
    end
  rescue => e
    import.failed!
    import.import_errors.create(
      contact_data: {},
      error_message: "Error al procesar archivo: #{e.message}"
    )
  end
end
