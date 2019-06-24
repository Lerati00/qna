Rails.application.routes.draw do
  root to: 'questions#index'

  get 'users/add_email', to: 'registration_supplements#add_email'
  post 'users/create_authorization', to: 'registration_supplements#create_authorization' 

  concern :commentable do
    resources :comments, only: :create
  end

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_cancel
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable],
              shallow: true, only: %i[create update destroy] do

      member do
        patch :best
      end
    end
  end

  mount ActionCable.server => '/cable'
end
