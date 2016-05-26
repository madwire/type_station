TypeStation::Engine.routes.draw do
  root :to => 'pages#index'

  namespace :admin, path: "_admin" do
    resources :pages, only: :index

    resources :entities, only: [:create, :update, :destroy] do
      get :move, on: :member
    end
  end

  get 'file-download/:identifier' => 'file#download', as: :download

  match "*path", to: "pages#show", via: :all
end
