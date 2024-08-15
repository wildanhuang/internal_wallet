Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :authentications, only: [] do
        collection do
          post    :login
          get     :keys
          delete  :logout
        end
      end

      resources :wallets, only: [:index] do
        collection do
          get   :balance
          post  :deposit
          post  :withdraw
        end
      end
    end
  end
end
