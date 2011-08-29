Houseaccounts::Application.routes.draw do
  get "pages/home"
  resources :groups do
    collection do 
      post :add_new_group, :join_new_group
      get :join, :add
    end
  end
  resources :members do
    resources :payments
    member do
      post :send_email
    end
  end
  resources :users do 
    collection do 
      post :validate, :send_password_update_link, :handle_password_reset
    end
  end
  
  match 'forgotten_password' => 'users#forgotten_password', :as => :forgotten_password
  match 'password_reset' => 'users#password_reset', :as => :password_reset
  match 'signin' => 'users#signin', :as => :signin
  match 'register' => 'users#new', :as => :register
  match '/signout' => 'users#signout', :as => :signout
  match '/' => 'pages#home', :as => :home
end
