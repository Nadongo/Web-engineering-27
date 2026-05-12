Rails.application.routes.draw do
  # 1. Setting root (Top Page)
  root 'pages#home'

  # 2. Authentication Routing (Login/Logout)
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  post '/guest_login', to: 'sessions#guest_login'
  post '/admin_guest_login', to: 'sessions#admin_guest_login'

  get '/my_bookshelf', to: 'users#bookshelf', as: 'my_bookshelf'
  get '/admin', to: 'admin#dashboard', as: 'admin_dashboard'
 
  # 4. RESTful Resources using 'only' to prevent extra routes
  resources :users
  
  # Standard CRUD for books
  resources :books

  resources :categories, only: [:index, :show, :create, :destroy]
  resources :borrow_requests, only: [:new, :create, :update, :destroy] do
    member do
      get :return_book
      patch :mark_returned
    end
  end
end