Rails.application.routes.draw do

  root "users#index"

  resources :users
  resource  :session,   only:   %i[new create destroy]
  resources :questions, except: %i[show new index]

  # get 'users/index'
  # get 'users/new'
  # get 'users/edit'
  # get 'users/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
