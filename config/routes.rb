Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    authenticated :user do
      root 'admin#index', as: :authenticated_root
    end
  
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  post '/send_otp', to: 'password_reset#send_otp'
  post '/verify_otp', to: 'password_reset#verify_otp'
  post '/password_reset', to: 'password_reset#reset_password' 
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
   get '/dashboard', to: 'admin#dashboard', as: :dashboard
   get '/adminprofile', to: 'admin#adminprofile', as: :adminprofile
end
