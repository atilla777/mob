class CalculateStarsJob < ApplicationJob
  SQL_QUIERY = NtileQuery

  queue_as :default

  def perform(*args)
    result = SQL_QUIERY.call
    result.each do | r |
      post = Post.where(r.post_id).first
      if post.present?
         post.stars = r.stars
         post.save
      end
    end
  end
end
