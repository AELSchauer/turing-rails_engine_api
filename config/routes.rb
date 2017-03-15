Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      get "/customers/find", to: "customers#find"
      get "/customers/find_all", to: "customers#find_all"
    end
  end

  namespace :api do
    namespace :v1 do
      resources :customers, only: [:index, :show] do
        resources :invoice, only: :index
        resources :transactions, only: :index
      end

      resources :invoices, only: [:index, :show] do
        resources :customer, only: :index
        resources :invoice_items, only: :index
        resources :items, only: :index
        resources :merchant, only: :index
        resources :transactions, only: :index
      end

      namespace :invoice_items do
        get "/find", to: "finders#show"
        get "/find_all", to: "finders#index"
        get "/:id/invoice", to: "invoice#show"
        get "/:id/item", to: "item#show"
      end
      resources :invoice_items, only: [:index, :show]

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
