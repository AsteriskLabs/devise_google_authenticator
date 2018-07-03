RailsApp::Application.routes.draw do
  devise_for :users

  resources :posts
  get 'foo' => 'foo#index'
  root :to => 'posts#index'
end
