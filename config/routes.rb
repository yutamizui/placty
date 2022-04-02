Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.map(&:to_s).join('|')}/ do 
    root to: 'events#index'
    resources :events do
      collection do
        get :joining
        get :hosting
        get :how_to_use
        post :add_point
        post :memo
      end
    end

    resources :notice_boards
    resources :invoices 
    resources :tickets 
    resources :notes do
      collection do
        post :duplicate
      end
    end
    
    devise_for :users, controllers: {
      sessions:      'users/sessions',
      passwords:     'users/passwords',
      registrations: 'users/registrations'
    }
  end

  get "locale" => "application#locale", as: "locale"
  get "introduction" => "home#introduction", as: "introduction"
  get "contact" => "home#contact", as: "contact"
  post "contact_sending" => "home#contact_sending", as: "contact_sending"
  post "payments/customer_registration"
  post "payments/payjpcard_update"
  get 'payments/price'
  post "payments/payjp_webhook"
  post "payments/charge"
  post "payments/redeem_point"
  post "payments/redeem_completed"
  post "payments/subscribe"
  post "payments/unsubscribe"
  get "payments" => "payments#index", as: "payments"
end
