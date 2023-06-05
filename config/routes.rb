Rails.application.routes.draw do
  
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

# resources :filterevents
get '/sort_events/start_date', to: 'events#sort_events'
get '/sort_events/start_time', to: 'events#sort_events'


  post 'users/forgot_passwrd', to: 'password_reset#send_otp'
  post 'users/verify_otp', to: 'password_reset#verify_otp'
  post 'users/reset_password', to: 'password_reset#reset_password' 


  post 'events/' ,to: 'events#create'
  get 'events',to: 'events#index'
  put 'events/:id' ,to:'events#update'
  delete 'events/:id' ,to:'events#destroy'
  get '/user_events', to: 'events#show_all' 
  get '/event_categories', to: 'events#event_categories'


  get '/sort_events', to: 'events#sort_events'


  post '/profile', to: 'profiles#create'
  put '/update_profile', to: 'profiles#update'
  get '/user_profile', to: 'profiles#show'
  delete '/profile', to: 'profiles#destroy'
  
end
