FactoryBot.define do
  factory :payment do
    payment_amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    association :loan
  end
end
