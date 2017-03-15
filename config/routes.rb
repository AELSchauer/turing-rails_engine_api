Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get 'revenue/index'
      end
    end
  end

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

      namespace :merchants do
        get "/find", to: "find#show"
        get "/find_all", to: "find#index"
      end
      resources :merchants, only: [:index, :show] do
        get "/revenue", to: "merchants/revenue#index"
        get "/invoices", to: "merchants/invoices#index"
        get "/items", to: "merchants/items#index"
      end

      resources :transactions, only: [:index, :show] do
        resources :invoice, only: :index
      end
    end
  end

end
