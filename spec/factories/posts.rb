FactoryGirl.define do
  factory :post do
    sequence(:name){ |n| "Post#{n}" }
    sequence(:body){ |n| "Post body#{n}" }
    user
  end
end
