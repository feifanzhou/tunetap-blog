Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'posts#index'
  get '/page/:index' => 'posts#index'

  get '/contributors/login' => 'contributors#login'
  post '/contributors/enter' => 'contributors#enter', as: :enter

  get '/search' => 'search#search'
  get '/tags/search' => 'tags#search'

  resources :posts
  get '/posts/:id/:slug' => 'posts#show'
  resources :tags
  get 'tags/:id/page/:index' => 'tags#show'
  get '/tags/:id/:slug' => 'tags#show'
  resources :contributors
  get '/contributors/:id/page/:index' => 'contributors#show'
  get '/contributors/:id/:slug' => 'contributors#show'
  resources :invitations
end