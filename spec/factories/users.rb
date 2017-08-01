FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    admin false
    writer false
    trait(:admin) {admin true}
    trait(:writer) {writer true}
    password "123456"
    description "I like icecream!"
    transient { confirmed true}
    after(:create) { |user, evaluator| user.confirm if evaluator.confirmed}
  end
end
