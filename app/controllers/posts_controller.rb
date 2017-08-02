class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post, nitice: 'Post was created'
    else
      render new_post_path, alert: 'Post was not created'
    end
  end

  def show
    @post = set_post
  end

  def edit
    @post = set_post
  end

  def update
    @post = set_post
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was updated'
    else
      render :edit, alert: 'Post was not updated'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:name, :body, :user_id)
  end
end
