Rails.application.routes.draw do
  get '/', to:'users#top'
  get '/top', to:'users#top', as: :top
  resources :posts
  get '/profile/edit', to:'users#edit', as: :profile_edit
  get '/profile/(:id)', to:'users#show', as: :profile
  get '/follower_list/(:id)', to:'users#follower_list', as: :follower_list
  get '/follow_list/(:id)', to:'users#follow_list', as: :follow_list
  get '/sign_up', to:'users#sign_up', as: :sign_up
  post '/sign_up',to:'users#sign_up_process'
  get '/sign_in', to:'users#sign_in', as: :sign_in
  post '/sign_in', to:'users#sign_in_process'
  get '/sign_out', to:'users#sign_out', as: :sign_out
 # post '/posts	', to:'posts#create'
  post '/profile/edit', to:'users#update'
  get '/follow/(:id)', to:'users#follow', as: :follow
  resources :posts do
    member do
      #get	/posts/(:id)/like	posts#like
      # いいね
      get 'like', to: 'posts#like', as: :like
    end
  end
  #post	/posts/(:id)/comment	posts#comment
  resources :posts do
    member do
      # コメント
      post 'comment', to: 'posts#comment', as: :comment
    end
  end
end