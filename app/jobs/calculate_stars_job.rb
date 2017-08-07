class CalculateStarsJob < ApplicationJob
  SQL_QUIERY = NtileQuery

  queue_as :saving_stars

  def perform(*args)
    rating = SQL_QUIERY.call # [[post_id, score_sum, star], ...]
    rating.each do | r |
      post = Post.where(id: r[0]).first
      if post.present?
         post.star = r[2]
         post.save
      end
    end
  end
end
