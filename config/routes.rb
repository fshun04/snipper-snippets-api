Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }

  jsonapi_resources :users
  jsonapi_resources :snippets

  # resources :snippets, only: [:index, :create], controller: 'snippets/snippets'

  # resources :users, controller: 'users/registrations' do
  #   resources :snippets, only: [:show, :update, :new, :destroy], controller: 'snippets/snippets'
  # end
end
