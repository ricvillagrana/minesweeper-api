Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :games

      post '/games/:game_id/reveal', to: 'games#reveal'
      post '/games/:game_id/flag',   to: 'games#flag'
    end
  end
end
