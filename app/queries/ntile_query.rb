class NtileQuery
  #BUCKETS = 5

  def self.call
#    Post.find_by_sql <<~SQL
#      SELECT posts.id as post_id,
#             sum(votes.score) as sum,
#             NTILE(5) OVER(ORDER BY 2) as stars
#      FROM posts
#      JOIN votes ON votes.post_id = posts.id
#      GROUP BY posts.id
#    SQL
#;
    #
#    Post.find_by_sql <<~SQL
#      with scores as
#        (select posts.id, sum(votes.score)
#         from posts join votes on votes.post_id = posts.id group by 1)
#      select scores.id, scores.sum, ntile(5) over(order by 2) as stars
#      from scores
#    SQL
    Vote.find_by_sql <<~SQL
      WITH scores AS
        (SELECT votes.post_id AS post_id,
          SUM(votes.score) AS score_sum
        FROM votes
        GROUP BY votes.post_id)
      SELECT scores.post_id, scores.score_sum,
             NTILE(5) OVER(ORDER BY scores.score_sum) AS stars
      FROM scores
    SQL
#kk    Post.find_by_sql <<~SQL
#kk      SELECT votes.post_id AS post_id,
#kk        SUM(votes.score) AS sum,
#kk        NTILE(5) OVER(ORDER BY 2) AS stars
#kk      FROM votes
#kk      GROUP BY votes.post_id
#kk    SQL
#    Post.find_by_sql <<~SQL
#      SELECT DISTINCT posts.id as post_id,
#             sum(votes.score) OVER(PARTITION BY post_id) as sum,
#             NTILE(5) OVER(ORDER BY 2) as stars
#      FROM posts
#      JOIN votes ON votes.post_id = posts.id
#    SQL
  end
end
