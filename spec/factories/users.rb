FactoryGirl.define do
  factory :user do
    name "Vasia Pugovkin"
    email "vasia.p@gmail.com"
    admin false
    password "123456"
    description "I like icecream!"
    transient { confirmed true}
    after(:create) { |user, evaluator| user.confirm if evaluator.confirmed}
  end
end
