require 'csv'

class ProcessCsvJob < ApplicationJob
  queue_as :default

  def perform(import_id)
    import = Import.find(import_id)
    import.update(status: :processing)

    file = import.file.download.force_encoding("UTF-8")
    csv = CSV.parse(file, headers: true)

    success = 0
    mapping = import.column_mapping || {}

    csv.each do |row|
      begin
        # Mapea las columnas según lo seleccionado por el usuario
        mapped_row = {}

        mapping.each do |expected_field, column_name|
          mapped_row[expected_field] = row[column_name]
        end

        ContactUser.create_from_csv(mapped_row, import.user, import)
        success += 1
      rescue => e
        # Los errores ya se registran en el modelo
        next
      end
    end

    # Actualiza el estado según el resultado
    if success > 0
      import.update(status: :finished)
      
    else
      import.update(status: :failed)
    end



  rescue => e
    import.update(status: :failed)
    import.import_errors.create(
      contact_data: {},
      error_message: "Error al procesar archivo: #{e.message}"
    )
  end
end
