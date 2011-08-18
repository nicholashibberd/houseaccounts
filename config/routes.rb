Houseaccounts::Application.routes.draw do
  get "pages/home"
  resources :groups do
    collection do 
      post :add_new_group, :join_new_group
    end
  end
  resources :members do
    resources :payments
  end
  resources :users do 
    collection do 
      post :validate
    end
  end
  
  match 'signin' => 'users#signin', :as => :signin
  match 'register' => 'users#new', :as => :register
  match '/signout' => 'users#signout', :as => :signout
  match '/' => 'pages#home', :as => :home
end
