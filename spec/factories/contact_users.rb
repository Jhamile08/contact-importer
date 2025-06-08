FactoryBot.define do
  factory :contact_user do
    name { "Claudia Pérez" }
    dob { "1990-05-12" }
    phone { "(+57) 301-555-12-34" }
    address { "Calle Falsa 123" }
    email { Faker::Internet.email }
    encrypted_cc { "123456789" }
    cc_network { "Visa" }
    user
    import
  end
end
