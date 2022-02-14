Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[new create update destroy] do
      patch :mark_best, on: :member
      patch :like
      patch :dislike
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
