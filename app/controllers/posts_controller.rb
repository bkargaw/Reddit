class PostsController < ApplicationController

  before_action :ensure_login, except: :show
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    @my_subs = []
    @subs = Sub.all
  end

  def create
    @post = Post.new(post_params)
    @post[:author_id] = current_user.id
    if @post.save
      flash[:notices] = ["created post!"]
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to new_post_url
    end
  end

  def show
    @post = Post.includes(:author).includes(:subs).find(params[:id])
  end

  def edit
    @my_subs = @post.subs
    # @post defined in #ensure_owner
    @subs = Sub.all
  end

  def update
    # @post defined in #ensure_owner
    if @post.update_attributes(post_params)
      flash[:notices] = ["updated post!"]
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to edit_post_url(@post)
    end
  end

  def destroy
    deleted_post = Post.delete(params[:id])
    flash[:errors] = ["not in our database!"] if deleted_post.nil?
    flash[:notices] = ["deleted post"] if deleted_post
    redirect_to sub_url(deleted_post.sub_id)
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end

  def ensure_owner
    @post = Post.find(params[:id])
    redirect_to root unless current_user == @post.author
  end
end
