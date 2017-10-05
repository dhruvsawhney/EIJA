Rails.application.routes.draw do
  resources :plays
  get "/plays/show"

  get 'home/homepage'

  root 'home#homepage'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
