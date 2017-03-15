Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :customers do
        get "/find", to: "customers#show"
        get "/find_all", to: "customers#index"
      end
      resources :customers, only: [:index, :show] do
        get "/transactions", to: "customers/transactions#index"
        get "/invoices", to: "customers/invoices#index"
      end

      resources :invoices, only: [:index, :show] do
        resources :customer, only: :index
        resources :invoice_items, only: :index
        resources :items, only: :index
        resources :merchant, only: :index
        resources :transactions, only: :index
      end
      resources :invoice_items, only: [:index, :show] do
        resources :invoice, only: :index
        resources :item, only: :index
      end
      resources :items, only: [:index, :show] do
        resources :invoice_items, only: :index
        resources :merchant, only: :index
      end
      resources :merchants, only: [:index, :show] do
        resources :invoices, only: :index
        resources :items, only: :index
      end
      resources :transactions, only: [:index, :show] do
        resources :invoice, only: :index
      end
    end
  end

end
