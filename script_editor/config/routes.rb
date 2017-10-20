Rails.application.routes.draw do
  devise_for :users
  resources :edit_plays
  get "/plays/:play" => "plays#show"

  get 'home/homepage'

  root 'home#homepage'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
