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

  resources :events 
  get '/show_all', to: 'events#show_all' 


  resources :profiles do
    collection do
    put :update
    delete :destroy
    get :show
    end
  end
  
end
