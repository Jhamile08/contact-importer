FactoryBot.define do
  factory :import do
    status { :on_hold }
    user
  end
end
