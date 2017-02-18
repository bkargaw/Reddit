class CommentsController < ApplicationController

  before_action :ensure_login, except: [:show, :index]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment[:author_id] = current_user.id
    @comment[:post_id] = params[:post_id]
    if @comment.save
      flash[:notices] = ["comment created!"]
    else
      flash[:errors] = @comment.errors.full_messages
    end
    redirect_to post_url(params[:post_id])
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
    # @comment defined in #ensure_owner
  end

  def update
    # @comment defined in #ensure_owner
    if @comment.update_attributes(comment_params)
      flash[:notices] = ["comment edited!"]
    else
      flash[:errors] = @comment.errors.full_messages
    end
    redirect_to post_url(params[:post_id])
  end

  def destroy
    deleted_comment = Comment.delete(params[:id])
    flash[:errors] = ["not in our database!"] if deleted_comment.nil?
    flash[:notices] = ["destroyed comment"] if deleted_comment
    redirect_to post_url(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_comment_id)
  end

  def ensure_owner
    @comment = Comment.find(params[:id])
    redirect_to root unless current_user == @comment.author
  end
end
