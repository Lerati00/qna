Rails.application.routes.draw do
  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_cancel
    end
  end

  devise_for :users
  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true, only: %i[create update destroy] do
      member do
        patch :best
      end
    end
  end
end
