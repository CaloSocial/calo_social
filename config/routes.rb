SampleApp::Application.routes.draw do
  devise_for :users
  #REST resources
  devise_scope :user do 
    match '/sessions/user', to: 'devise/sessions#create', via: :post
  end

  resources :users do
    # routes lool like /users/1/following and /users/1/followers
    # GET /users/1/following  following following_user_path(1)
    # GET /users/1/followers  followers followers_user_path(1)
    member do
      get :following, :followers
    end
  end

# RESTful routes provided by the Users resource: 
# GET /users  index users_path  page to list all users
# GET /users/1  show  user_path(user) page to show user
# GET /users/new  new new_user_path page to make a new user (signup)
# POST  /users  create  users_path  create a new user
# GET /users/1/edit edit  edit_user_path(user)  page to edit user with id 1
# PATCH /users/1  update  user_path(user) update user
# DELETE  /users/1  destroy user_path(user) delete user

  # resources :sessions, only: [:new, :create, :destroy]

#   POST  /microposts create  create a new micropost
# DELETE  /microposts/1 destroy delete micropost with id 1

  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

#   POST  /swaps create  create a new swap
# DELETE  /swaps/1 destroy delete swap with id 1
# PATCH   /swaps/1 update swap_path(swap)

  resources :swaps, only: [:index, :create, :destroy, :update]

  get 'tags/:tag', to: 'swaps#index', as: :tag
  get 'place/', to: 'swaps#nearby'

  root  'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  #users:
  # match '/signup',  to: 'users#new',  via: 'get'
  # #Authentication:
  # match '/signin',  to: 'sessions#new',         via: 'get'
  # match '/signout', to: 'sessions#destroy',     via: 'delete'

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
