require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  concern :paginatable do
    get "(page/:page)", action: :index, on: :collection, as: ""
  end
  root to: "static_pages#home"

  get "static_pages/help"

  get "static_pages/contact"

  get "static_pages/about"
  resources :users, only: :show
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: [:create, :destroy]
  resources :activities
  resources :categories, concerns: :paginatable, only: [:index, :show]
  authenticate :user, lambda {|u| u.is_admin?} do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :lessons, except: :destroy do
    resources :results, except: [:create, :destroy]
  end

  namespace :admin do

  resources :lessons, except: :destroy do
    resources :results, except: [:create, :destroy]
  end

    resources :categories, concerns: :paginatable do
      resources :words
    end
    resources :users, concerns: :paginatable, only: [:index, :destroy]
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
