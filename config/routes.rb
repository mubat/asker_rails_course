Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  concern :votable do
    member do
      patch :like
      patch :dislike
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, only: %i[new create update destroy], concerns: [:votable] do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :votes, only: :destroy

  mount ActionCable.server => '/server'
end
