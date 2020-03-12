Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  resources :merchants

  resources :items, only: [:index, :show, :edit, :update]

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  post "/cart", to: "cart#increment_decrement"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, only: [:new, :create, :show]

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'
  get '/profile', to: 'users#show'

  get '/password/edit', to: 'password#edit'
  patch '/password', to: 'password#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/:order_id', to: 'user_orders#show'
  delete '/profile/orders/:order_id', to: 'user_orders#destroy'

  namespace :merchant do
    root "dashboard#show"
    resources :items
    resources :orders, only: :show
    resources :discounts, except: :show

    post '/items/:item_id', to: 'items#activate_deactivate_item'
    patch '/orders/:order_id/item_order/:item_order_id', to: "orders#fulfill"
  end

  namespace :admin do
    root "dashboard#index"
    resources :users, only: [:index, :show]
    resources :merchants, only: [:show, :index]

    patch '/orders/:order_id', to: 'dashboard#update'
    patch '/merchants/:id', to: 'merchants#enable_disable_merchant'
  end
end
