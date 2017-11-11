Rails.application.routes.draw do
  get 'privilege/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'default/index#index'

  #login
  get '/login' , to: 'login#index'
  post '/login' , to: 'login#login'
  get '/logout', to: 'login#logout'

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
  #resources :post
  get '/post' , to: 'post#index'
  get 'export_data', to: 'post#export_data'
  get 'post/update_data', to: 'post#update_data'

  get '/:group_id/post' , to: 'post#index'
  get '/:group_id/export_data', to: 'post#export_data'
  get '/:group_id/post/update_data', to: 'post#update_data'



  #profile
  get '/profile' , to: 'profile#index'
  patch '/profile/update' , to: 'profile#update'

  get '/permission/:id', to: 'permission#show'
  patch '/permission/update' , to: 'permission#update'

  #auth facebook
  get 'auth/facebook', as: "auth_provider"
  get 'auth/facebook/callback', to: 'login#facebook'


  # default  
  get '/group/:group_id/post' , to: 'default/post#index'

  get '/category/:identify(/:sub_indetify)' , to: 'default/group#index'

  get '/404.html' , to: 'default/error#404'
end
