class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by_credentials(params[:user][:username],
                                            params[:user][:password])
    if user
      login(user)
      redirect_to subs_url
    else
      flash[:errors] = ['username or password invalid']
      redirect_to new_session_url
    end

  end

  def destroy
    if logged_in?
      logout
      redirect_to new_session_url
    end
  end
end
