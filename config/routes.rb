Rails.application.routes.draw do
  resources :users, only: [:new,:create]
  resource :session, only: [:new, :create, :destroy]
  resources :subs
  resources :posts, except: :index do
    resources :comments, except: [:index]
  end

  root 'subs#index'
end
