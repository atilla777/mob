module ApplicationHelper
  def like_button_class(rating)
    if rating.user_score == 1
      'btn btn-xs btn-info'
    else
      'btn btn-xs btn-default'
    end
  end

  def dislike_button_class(rating)
    if rating.user_score == -1
      'btn btn-xs btn-info'
    else
      'btn btn-xs btn-default'
    end
  end
end
