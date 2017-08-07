ThinkingSphinx::Index.define :post, :with => :real_time do
  scope { Post.includes(:comments) }
  # fields
  indexes name, sortable: true
  indexes body
  indexes user.name, as: :author, sortable: true
  indexes comments_string, as: :comments

  # attributes
  has user_id,  type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
