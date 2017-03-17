Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      namespace :customers do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
        get "/random", to: "random#show"
      end
      resources :customers, only: [:index, :show] do
        get "/transactions", to: "customers/transactions#index"
        get "/invoices", to: "customers/invoices#index"
        get "/favorite_merchant", to: "customers/favorite_merchant#show"
      end

      namespace :invoices do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
        get "/random", to: "random#show"
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
        get "/random", to: "random#show"
      end
      resources :invoice_items, only: [:index, :show] do
        get "/invoice", to: "invoice_items/invoice#show"
        get "/item", to: "invoice_items/item#show"
      end

      namespace :items do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
        get "/random", to: "random#show"
        get "/most_revenue", to: "most_revenue#index"
      end
      resources :items, only: [:index, :show] do
        get "/invoice_items", to: "items/invoice_items#index"
        get "/merchant", to: "items/merchant#show"
        get "/best_day", to: "items/best_day#show"
      end

      namespace :merchants do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
        get "/random", to: "random#show"
        get "/revenue", to: "revenue#index"
        get "/most_items", to: "most_items#index"
      end
      resources :merchants, only: [:index, :show] do
        get "/revenue", to: "merchants/revenue#show"
        get "/invoices", to: "merchants/invoices#index"
        get "/items", to: "merchants/items#index"
      end

      namespace :transactions do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
        get "/random", to: "random#show"
      end
      resources :transactions, only: [:index, :show] do
        get "/invoice", to: "transactions/invoice#show"
      end

    end
  end

end
