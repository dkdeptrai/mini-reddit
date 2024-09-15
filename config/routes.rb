Rails.application.routes.draw do
  resources :votes
  resources :posts do
    member do
      post 'upvote', to: 'votes#upvote'
      post 'downvote', to: 'votes#downvote'
    end
    resources :comments, only: %i[new create] do
      member do
        post 'upvote', to: 'votes#upvote'
        post 'downvote', to: 'votes#downvote'
      end
    end
  end

  resources :comments, only: [:show, :edit, :update, :destroy] do
    resources :comments, only: [:create]
    member do
      post 'upvote', to: 'votes#upvote'
      post 'downvote', to: 'votes#downvote'
    end
  end


  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "posts#index"
end
