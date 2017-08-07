class NtileQuery
  MAX_STARS = 5 # ntile(buckets)

  def self.call
    Vote.find_by_sql([<<~SQL, stars: MAX_STARS]).pluck(:post_id, :score_sum, :star)
      WITH scores AS
        (SELECT votes.post_id AS post_id,
          SUM(votes.score) AS score_sum
         FROM votes
         GROUP BY votes.post_id)
      SELECT scores.post_id, scores.score_sum,
             NTILE(:stars) OVER(ORDER BY scores.score_sum) AS star
      FROM scores
    SQL
  end
end
