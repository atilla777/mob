class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    vote = Vote.find_or_initialize_by(post_id: @post.id, user_id: current_user.id)
    authorize! :create, vote, message: t('views.message.vote_restrict')
    vote.score = vote_params[:score]
    vote.save
    @rating = RatingPresenter.new(@post, current_user)
  end

  private

  def vote_params
    params.require(:vote).permit(:post_id, :user_id, :score)
  end
end
