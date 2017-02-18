class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def login(user)
    @current_user = user
    flash[:notices] = ["You're logged in!"]
    session[:session_token] = user.reset_session_token
  end

  def logout
    session[:session_token] = nil
    flash[:notices] = ["You're logged out!"]
    @current_user = nil
  end

  def ensure_login
    unless logged_in?
      redirect_to new_session_url
      flash[:errors] = ['it looks like you like our site; you might want to sign up']
    end

  end

end
