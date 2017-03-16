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
        get "/favorite_merchant", to: "customers/favorite_merchant#show"
      end

      namespace :invoices do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :invoices, only: [:index, :show] do
        get "/customer", to: "invoices/customer#show"
        get "/invoice_items", to: "invoices/invoice_items#index"
        get "/items", to: "invoices/items#index"
        get "/merchant", to: "invoices/merchant#show"
        get "/transactions", to: "invoices/transactions#index"
      end

      namespace :invoice_items do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :invoice_items, only: [:index, :show] do
        get "/invoice", to: "invoice_items/invoice#show"
        get "/item", to: "invoice_items/item#show"
      end

      namespace :items do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :items, only: [:index, :show] do
        get "/invoice_items", to: "items/invoice_items#index"
        get "/merchant", to: "items/merchant#show"
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
