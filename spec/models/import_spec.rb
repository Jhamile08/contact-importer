require 'rails_helper'

RSpec.describe Import, type: :model do
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  it "renders import partial with correct content" do
    import = create(:import, status: :on_hold)

    # Simular que hubo cambio
    import.update(status: :processing)

    rendered = ApplicationController.render(
      partial: "imports/import",
      locals: {
        import: import,
        contacts: import.contact_users.page(1).to_a,
        errors: import.import_errors.page(1).to_a
      }
    )

    expect(rendered).to include("Status:")
    expect(rendered).to include("Uploaded at:")
  end
end
