Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'default/index#index'
  
  #batch
  namespace :batch do
    resources :post

  end

  #login
  get '/login' , to: 'login#index'
  post '/login' , to: 'login#login'
  get '/logout', to: 'login#logout'
  get 'privilege/index'
  resources :dashboard

  # user list
  resources :user

  resources :module

  resources :resource

  resources :privilege

  resources :role
  resources :site
  #resources :my-groups
  get 'my-groups' , to: 'my_groups#index'
  post 'my-groups', to: 'my_groups#create'

  get 'facebook-group' , to: 'my_groups#facebook_group'
  get 'search-open-groups' , to: 'my_groups#facebook_public'

  #resources :post
  get '/post' , to: 'post#index'
  get '/:group_id/post/:post_id/' , to: 'default/post#show'
  get 'export_data', to: 'post#export_data'
  get 'post/update_data', to: 'post#update_data'

  get '/:group_id/post' , to: 'post#index'
  get '/:group_id/export_data', to: 'post#export_data'
  get '/:group_id/post/update_data', to: 'post#update_data'

  get '/:group_id/member' , to: 'member#index'
  get '/:group_id/member/export_data', to: 'member#export_data'
  get '/:group_id/member/update_data', to: 'member#update_data'

  #profile
  get '/profile' , to: 'profile#index'
  patch '/profile/update' , to: 'profile#update'

  get '/permission/:id', to: 'permission#show'
  patch '/permission/update' , to: 'permission#update'

  #auth facebook
  get 'auth/facebook', as: "auth_provider"
  get 'auth/facebook/callback', to: 'login#facebook'


  # default
  get '/404.html' , to: 'default/error#404'
  get '/group/:group_id/post' , to: 'default/post#index'
  get '/group/:group_id/member' , to: 'default/member#index'
  get '/group/:group_id/member/:member_id' , to: 'default/member#show'
  get '/group/:group_id' , to: 'default/group#show'

  get '/category/:identify(/:sub_indetify)' , to: 'default/group#index'
  get '/tim-kiem' , to: 'default/search#index'

  
end
