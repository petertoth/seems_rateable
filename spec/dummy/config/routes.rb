Dummy::Application.routes.draw do
  seems_rateable
  resources :posts

  devise_for :users

  root to: "posts#index"
end
