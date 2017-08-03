FactoryGirl.define do
  factory :comment do
    post { Post.first || association(:post) }
    user { User.first || association(:user) }
    sequence(:body) { | n | "Body#{n}" }
  end
end
