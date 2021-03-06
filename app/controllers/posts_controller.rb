class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    authorize! :index, Post
    if params[:filter].present?
      posts = Post.search(params[:filter])
      @posts = Post.where(id: posts)
    else
      @posts = Post.all
    end
    @posts = @posts.includes(:user)
                   .page(params[:page])
                   .order(created_at: :desc)
  end

  def new
    authorize! :new, Post
    @post = Post.new
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))
    authorize! :create, @post
    if @post.save
      redirect_to @post, nitice: 'Post was created'
    else
      render new_post_path, alert: 'Post was not created'
    end
  end

  def show
    @post = Post.where(id: params[:id])
                .includes(:user)
                .includes(:comments)
                .first
    authorize! :show, Post
    @comments = @post.comments.order(created_at: :desc)
    @comments = @comments.page(params[:page])
    @comment = Comment.new
    @rating = RatingPresenter.new(@post, current_user)
  end

  def edit
    @post = set_post
    authorize! :show, @post
  end

  def update
    @post = set_post
    authorize! :show, @post
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was updated'
    else
      render :edit, alert: 'Post was not updated'
    end
  end

  def destroy
    @post = set_post
    authorize! :show, @post
    @post.destroy
    redirect_to posts_path, notice: 'Post was destroyed'
  end

  def set_stars
    CalculateStarsJob.perform_later
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:name, :body, :user_id)
  end
end
