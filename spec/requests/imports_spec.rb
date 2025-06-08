require 'rails_helper'

RSpec.describe "Imports", type: :request do
  let(:user) { create(:user) }
  let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures/files/valid_contacts.csv"), "text/csv") }

  before do
    sign_in user
  end

  it "creates an import and redirects to map_columns" do
    post imports_path, params: { import: { file: file } }

    expect(response).to redirect_to(map_columns_import_path(Import.last))
    follow_redirect!
    expect(response.body).to include("Map CSV Columns")
  end

end
