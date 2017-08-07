FactoryGirl.define do
  factory :vote do
    post
    user
    score 1
    trait(:like) { score(1)}
    trait(:dislike) { score(-1) }
  end
end
