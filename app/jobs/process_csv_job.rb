require 'csv'

class ProcessCsvJob < ApplicationJob
  queue_as :default  # This job will be added to the default Sidekiq queue

  def perform(import_id)
    # Find the import by ID
    import = Import.find(import_id)

    # Mark status as processing
    import.update(status: :processing)

    # Download the attached CSV file and decode it
    file = import.file.download.force_encoding("UTF-8")
    csv = CSV.parse(file, headers: true)  # Parse CSV with headers

    success = 0
    mapping = import.column_mapping || {}  # Get column mapping (from user), or empty

    csv.each do |row|
      begin
        # Build a hash with expected keys using user mapping
        mapped_row = {}

        mapping.each do |expected_field, column_name|
          mapped_row[expected_field] = row[column_name]
        end

        # Try to create a ContactUser record
        ContactUser.create_from_csv(mapped_row, import.user, import)
        success += 1

      rescue => e
        # Any errors inside create_from_csv are already logged
        next
      end
    end

    # Update status depending on success
    if success > 0
      import.update(status: :finished)
    else
      import.update(status: :failed)
    end

  rescue => e
    # If there was a major error (e.g., can't parse file), mark as failed
    import.update(status: :failed)

    # Save the error message
    import.import_errors.create(
      contact_data: {},
      error_message: "Error processing file: #{e.message}"
    )
  end
end
