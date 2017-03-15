Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      namespace :customers do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :customers, only: [:index, :show] do
        get "/transactions", to: "customers/transactions#index"
        get "/invoices", to: "customers/invoices#index"
      end

      namespace :invoices do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :invoices, only: [:index, :show] do
        get "/customer", to: "invoices/customer#show"
        resources :invoice_items, only: :index
        resources :items, only: :index
        resources :merchant, only: :index
        resources :transactions, only: :index
      end

      namespace :invoice_items do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :invoice_items, only: [:index, :show] do
        get "/invoice", to: "invoice_items/invoice#show"
        get "/item", to: "invoice_items/item#show"
      end

      resources :items, only: [:index, :show] do
        resources :invoice_items, only: :index
        resources :merchant, only: :index
      end

      namespace :merchants do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :merchants, only: [:index, :show] do
        get "/revenue", to: "merchants/revenue#index"
        get "/invoices", to: "merchants/invoices#index"
        get "/items", to: "merchants/items#index"
      end

      namespace :transactions do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :transactions, only: [:index, :show] do
        get "/invoice", to: "transactions/invoice#show"
      end

    end
  end

end
