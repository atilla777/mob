class Post < ApplicationRecord
  validates :name, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  belongs_to :user

  delegate :anme, to: :user

  def show_created_at
    strftime(create_at, "%d.%m.%Y")
  end
end
