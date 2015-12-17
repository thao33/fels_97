Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  root 'static_pages#home'
  get 'home' => 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  get "/auth/:provider/callback", :to => "sessions#create"
  get "/auth/failure", :to => "sessions#failure"
  get    'logout'  => 'sessions#destroy'

  resources :users do
    get "followings" => "relationships#index", defaults: {type: "following"}
    get "followers" => "relationships#index", defaults: {type: "followers"}
  end
  resources :relationships, only: [:create, :destroy]
  resources :words, only: :index
  resources :lessons, only: [:new, :create, :show, :update] do
    get "result" => "lessons#show", defaults: {type: "result"}
  end
  resources :categories
end
