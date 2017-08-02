class Comment < ApplicationRecord
  validates :post_id, numericality: {only_integer: true}
  validates :user_id, numericality: { only_integer: true }
  validates :body, presence: true

  belongs_to :post
  belongs_to :user

  delegate :name, to: :user, prefix: true

  def show_created_at
    created_at.strftime("%d.%m.%Y %H:%M")
  end
end
