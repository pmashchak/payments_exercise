FactoryBot.define do
  factory :loan do
    funded_amount { Faker::Number.decimal(l_digits: 4) }

    trait :with_outstanding_balance do
      after(:create) do |loan, evaluator|
        create_list(:payment, 2, loan: loan)
      end
    end
  end
end
