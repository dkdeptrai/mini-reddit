Rails.application.routes.draw do

  post 'update_theme', to: 'theme#update_theme'
  get 'load_theme', to: 'theme#load_theme'
  resources :posts do
    member do
      post 'upvote', to: 'votes#upvote'
      post 'downvote', to: 'votes#downvote'
    end
    resources :comments do
      member do
        post 'upvote', to: 'votes#upvote'
        post 'downvote', to: 'votes#downvote'
      end
    end
  end



  resources :comments do
    member do
      post 'upvote', to: 'votes#upvote'
      post 'downvote', to: 'votes#downvote'
    end
    resources :comments
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get "up" => "rails/health#show", as: :rails_health_check

  root "posts#index"
end

