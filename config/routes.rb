Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :resources, :upgrades
      resources :types, :inventories, :colony_components, :components, :inventory_components, :component_resources, :mine_upgrades, :ships, :spaceport_ships, :inventory_ships, :ship_components, only: [:index]


      resources :users do
        collection do
          get :topTen
        end
        member do
          get :showMines
        end
      end
      post "/login", to: "users#login"
      get "/auto_login", to: "users#auto_login"

      resources :inventory_resources, only: [] do
        member do
          put :mined
          put :transfer
        end
      end

      resources :mines do
        member do
          put :buy
        end
      end

      resources :colonies, :spaceports, only: [:index, :show] do
        member do
          put :research
          put :produce
        end
      end
      
    end
  end
end
