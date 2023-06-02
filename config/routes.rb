Rails.application.routes.draw do
  
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  post '/send_otp', to: 'password_reset#send_otp'
  post '/verify_otp', to: 'password_reset#verify_otp'
  post '/password_reset', to: 'password_reset#reset_password' 

  resources :events 
  get '/show_all', to: 'events#show_all' 


  resources :profiles do
    collection do
    put :update
    delete :destroy
    get :show
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  #Admin Panel Routes
  devise_scope :user do
    authenticated :user do
      root 'admin/home#dashboard', as: :authenticated_root
    end
  
    unauthenticated do
      root 'admin/auth/sessions#new', as: :unauthenticated_root
    end
  end

  namespace :admin do
    get 'login', to: 'auth/sessions#new', as: :login
    post 'login', to: 'auth/sessions#create', as: :post_login
    delete 'logout', to: 'auth/sessions#destroy', as: :logout
    get '/profile', to: 'home#profile', as: :profile
    get 'forgot-password', to: 'auth/passwords#new', as: :forgot_password
    post 'forgot/send_mail',to: "auth/passwords#passwordreset", as: :send_reset_instructions
    resources :users, except: [:new, :create,:edit,:update] do
      member do
        patch 'update_status'
      end
    end

  end

  
end
