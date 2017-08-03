class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
       @comment = Comment.new
    end
    @comments = @post.reload.comments.order(created_at: :desc)
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
    else
      @stored_body = Comment.find(params[:id]).body
    end
    @comments = @post.comments.order(created_at: :desc)
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :user_id, :body)
  end
end
