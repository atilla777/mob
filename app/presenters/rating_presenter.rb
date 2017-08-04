class RatingPresenter
  attr_reader :user_score,
              :likes_count,
              :dislikes_count,
              :total_score

  def initialize(post, user)
    @post = post
    @user = user
    @user_score = set_user_score
    @likes_count = set_likes_count
    dislikes_count = set_dislikes_count
    @total_score = @likes_count + dislikes_count
    @dislikes_count = -dislikes_count
  end

  private
  def set_user_score
    if @user
      Vote.where(post_id: @post.id,
                 user_id: @user.id)
          .first&.score || 0
    else
      0
    end
  end

  def set_likes_count
    Vote.where(post_id: @post.id, score: 1)
        .sum(:score) || 0
  end

  def set_dislikes_count
    Vote.where(post_id: @post.id, score: -1)
        .sum(:score) || 0
  end
end
