require 'rails_helper'

RSpec.describe ContactUser, type: :model do
  let(:user) { create(:user) }
  let(:import) { create(:import, user: user) }

  it "is valid with valid attributes" do
    contact = build(:contact_user, user: user, import: import)
    expect(contact).to be_valid
  end

  it "is invalid with malformed email" do
    contact = build(:contact_user, email: "not-an-email", user: user, import: import)
    expect(contact).not_to be_valid
  end

  it "detects Visa card" do
    expect(ContactUser.detect_network("4111111111111111")).to eq("Visa")
  end

  it "encrypts the credit card" do
    encrypted = ContactUser.encrypt_card_number("4111111111111111")
    expect(encrypted).to be_a(String)
    expect(encrypted.length).to eq(64) # SHA256
  end
end
