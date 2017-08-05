FactoryGirl.define do
  factory :vote do
    post { Post.first || asociation(:user) }
    user { User.first || asociation(:user) }
    score 1
    trait(:like) { score(1)}
    trait(:dislike) { score(-1) }
  end
end
