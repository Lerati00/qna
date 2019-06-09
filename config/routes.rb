Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end
end
