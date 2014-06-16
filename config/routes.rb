SeemsRateable::Engine.routes.draw do
  resources :rates, only: :create
end
