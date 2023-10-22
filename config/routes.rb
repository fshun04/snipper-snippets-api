Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :snippets, only: :index, controller: 'snippets/snippets'

  resources :users, controller: 'users/registrations' do
    resources :snippets, only: [:show, :create, :update, :new, :destroy], controller: 'snippets/snippets'
  end
end
