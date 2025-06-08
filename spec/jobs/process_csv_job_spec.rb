require 'rails_helper'

RSpec.describe ProcessCsvJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/valid_contacts.csv"), "text/csv") }
  let(:import) { create(:import, user: user) }

  before do
    import.file.attach(file)
    import.update!(
      column_mapping: {
        "name" => "name",
        "date_of_birth" => "date_of_birth",
        "phone" => "phone",
        "address" => "address",
        "email" => "email",
        "credit_card_number" => "credit_card_number"
      }
    )
  end

  it "processes a valid CSV and sets status to finished" do
    expect {
      described_class.perform_now(import.id)
    }.to change(ContactUser, :count).by_at_least(1)

    expect(import.reload.status).to eq("finished")
  end
end
