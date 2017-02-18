class SubsController < ApplicationController

  before_action :ensure_login, except: [:show, :index]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @subs = Sub.all
  end

  def new
    @sub= Sub.new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub[:moderator_id] = current_user.id
    if @sub.save
      flash[:notices] = ["created sub!"]
      redirect_to sub_url(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      redirect_to new_sub_url
    end
  end

  def show
    @sub = Sub.includes(:moderator).includes(:posts).find(params[:id])
  end

  def edit
    # @sub defined in #ensure_owner
  end

  def update
    # @sub defined in #ensure_owner
    if @sub.update_attributes(sub_params)
      flash[:notices] = ["updated sub!"]
      redirect_to sub_url(@sub)
    else
      flash[:errors] = @sub.errors.full_messages
      redirect_to edit_sub(@sub)
    end
  end

  def destroy
    deleted_sub = Sub.delete(params[:id])
    flash[:errors] = ["not in our database!"] if deleted_sub.nil?
    flash[:notices] = ["destroyed sub"] if deleted_sub
    redirect_to subs_url
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def ensure_owner
    @sub = Sub.find(params[:id])
    redirect_to root unless current_user == @sub.moderator
  end
end
