class NtileQuery
  #BUCKETS = 5

  def self.call
    Post.find_by_sql <<~SQL
      SELECT posts.id,
             sum(votes.score) as sum,
             NTILE(5) OVER(ORDER BY 1) as stars
      FROM posts, votes
      WHERE posts.id = votes.post_id
      GROUP BY posts.id
    SQL
  end
end
