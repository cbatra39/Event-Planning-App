Rails.application.routes.draw do
  
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    confirmations: 'users/confirmations' ,
    registrations: 'users/registrations'
  }

  # post '/users/confirmations', to: 'users/confirmations#create', as: 'confirm_user_account'
  post '/report', to: 'events#report'
  
  get '/sort_events/start_date', to: 'events#sort_events'
  get '/sort_events/start_time', to: 'events#sort_events'

  get '/search_events', to: 'events#search_events'
 
  post '/mark_favourite', to: 'events#mark_favourite'
  post '/join_event', to: 'events#join_event'
  post '/follow_user', to: 'events#follow_user'
  post '/like_event', to: 'events#like_event'


  post 'users/forgot_passwrd', to: 'password_reset#send_otp'
  post 'users/verify_otp', to: 'password_reset#verify_otp'
  post 'users/reset_password', to: 'password_reset#reset_password' 


  post 'events/' ,to: 'events#create'
  get 'events',to: 'events#index'
  put 'events/:id/' ,to:'events#update'
  delete 'events/:id/' ,to:'events#destroy' 
  get '/user_events', to: 'events#show_all' 
  get '/favourite_events', to: 'events#favorite_events'
  get '/event_categories', to: 'events#event_categories'
  get '/events_nearby', to: 'events#events_nearby'
  get '/events_details/:id', to: 'events#events_details'
  get '/user_details/:id', to: 'events#user_details'
  get '/search_events/:search_by', to: 'events#search_events'


  get '/sort_events', to: 'events#sort_events'


  post '/profile', to: 'profiles#create'
  put '/update_profile', to: 'profiles#update'
  get '/user_profile', to: 'profiles#show'
  delete '/profile', to: 'profiles#destroy'
  
end
