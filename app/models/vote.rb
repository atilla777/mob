class Vote < ApplicationRecord
  validates :user_id, numericality: { only_integer: true }
  validates :post_id, numericality: { only_integer: true }
  validates :score, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: :post_id }

  #validate :user_wont_vote_himself

  belongs_to :post
  belongs_to :user

  private

#  def user_wont_vote_himself
#    user_id != Post.find(post_id).user_id
#  end
end
