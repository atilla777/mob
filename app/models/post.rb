class Post < ApplicationRecord
  validates :name, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  belongs_to :user

  delegate :name, to: :user, prefix: true

  def show_created_at
    created_at.strftime("%d.%m.%Y %H:%M")
  end
end
