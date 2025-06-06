class ContactUser < ApplicationRecord
  belongs_to :user
  belongs_to :import

  validates :name, format: { with: /\A[a-zA-Z\s\-]+\z/, message: "solo letras y guiones permitidos" }
  validates :dob, presence: true
  validates :phone, format: { with: /\A\(\+\d{2}\)\s\d{3}[\s-]\d{3}[\s-]\d{2}[\s-]\d{2}\z/, message: "debe tener el formato (+XX) XXX-XXX-XX-XX" }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }
  validates :address, presence: true


      VALID_LENGTHS = {
      "American Express" => 15,
      "Diners Club" => 14,
      "Discover" => 16,
      "JCB" => 16,
      "MasterCard" => 16,
      "Visa" => [13, 16]
    }

def self.create_from_csv(row, user, import)
  raw_card = row["credit_card_number"].to_s.gsub(/\s|-/, "")
  network = detect_network(raw_card)

  contact = user.contact_users.new(
    name: row["name"],
    dob: formatted_date(row["date_of_birth"]),
    phone: row["phone"],
    address: row["address"],
    email: row["email"],
    encrypted_cc: encrypt_card_number(raw_card),
    cc_network: network,
    import: import
  )

  errors = []

  # Validaciones propias de tarjeta
  errors << "Red de tarjeta desconocida" if network == "Unknown"
  errors << "Longitud inválida para #{network}" if !valid_length_for?(raw_card, network)

  # Validaciones de modelo (nombre, email, etc.)
  unless contact.valid?
    errors += contact.errors.full_messages
  end

  if errors.any?
    import.import_errors.create(
      contact_data: row.to_h,
      error_message: errors.join(", ")
    )
  else
    contact.save!
  end
rescue => e
  import.import_errors.create(contact_data: row.to_h, error_message: e.message)
end



  def self.detect_network(card_number)
    case card_number
    when /^3[47][0-9]{13}$/ then "American Express"
    when /^3(?:0[0-5]|[68][0-9])[0-9]{11}$/ then "Diners Club"
    when /^6(?:011|5[0-9]{2})[0-9]{12}$/ then "Discover"
    when /^(?:2131|1800|35\d{3})\d{11}$/ then "JCB"
    when /^5[1-5][0-9]{14}$/ then "MasterCard"
    when /^4[0-9]{12}(?:[0-9]{3})?$/ then "Visa"
    else "Unknown"
    end
  end

  def self.valid_length_for?(card_number, network)


    valid = VALID_LENGTHS[network]
    return false unless valid

    valid.is_a?(Array) ? valid.include?(card_number.length) : valid == card_number.length
  end

  def self.encrypt_card_number(card_number)
    Digest::SHA256.hexdigest(card_number)
  end

  def self.formatted_date(date_str)
    Date.strptime(date_str, "%Y%m%d") rescue Date.iso8601(date_str) rescue nil
  end
end
