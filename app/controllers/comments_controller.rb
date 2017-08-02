class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    comment = @post.comments.build(comment_params)
    comment.user_id = current_user.id
    comment.save
    @comments = @post.reload.comments
    @comment = Comment.new
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :user_id, :body)
  end
end
