Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :show, :create, :update, :destroy] do
    resources :artworks, only: [:index]
  end
  resources :artworks, only: [:show, :create, :update, :destroy]
  resources :artwork_shares, only: [:create, :destroy]


  # get 'users/', to: 'users#index', as: 'root'
  # get 'users/:id', to: 'users#show', as: 'user'
  # post 'users/', to: 'users#create'
  # get 'users/new', to: 'users#new', as: 'new_user'
  # get '/users/:id/edit', to: 'users#edit', as: 'edit'
  # patch '/users/:id', to: 'users#update'
  # put '/users/:id', to: 'users#update'
  # delete '/users/:id', to: 'users#destroy'

  root to: 'users#index'
end
