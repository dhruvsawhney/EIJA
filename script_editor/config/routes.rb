Rails.application.routes.draw do
  post 'line_cuts/new'

  post 'line_cuts/delete'

  post 'cuts/new'
  post 'cuts/delete'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_for :admins, controllers: { registrations: 'admins/registrations' }
  resources :edit_plays
  resources :plays
  resources :edits
  get '/users/:id' => 'users#show', :as => :user
  get '/makenewedit/:id' => 'edits#new'
  get '/plays/show'
  get '/edits/show'
  get '/edits/compress'
  get '/edits/compress/:id' => 'edits#compress'
  get 'home/homepage'
  root 'home#homepage'
  get 'pages/about'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
