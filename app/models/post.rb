class Post < ApplicationRecord
  paginates_per 5

  after_save ThinkingSphinx::RealTime.callback_for(:post)

  validates :name, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  delegate :name, to: :user, prefix: true

  def show_created_at
    created_at.strftime("%d.%m.%Y %H:%M")
  end

  def comments_string
    comments.pluck(:body).join(' ')
  end
end
