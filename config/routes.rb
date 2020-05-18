Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :games

      post '/users/sign_in', to: 'users#sign_in'

      post '/games/:id/reveal', to: 'games#reveal'
      post '/games/:id/flag',   to: 'games#flag'
      post '/games/:id/unflag', to: 'games#unflag'
    end
  end
end
