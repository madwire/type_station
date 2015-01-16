TypeStation::Engine.routes.draw do
  root :to => 'pages#index'

  namespace :admin, path: "_admin" do
    resources :pages, only: [:update]
  end

  match "*path", to: "pages#show", via: :all
end
