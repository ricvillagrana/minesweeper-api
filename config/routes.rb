Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :games

      post '/games/reveal', to: 'games#reveal'
    end
  end
end
