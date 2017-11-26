Rails.application.routes.draw do
    resources :users
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    get 'base', to: 'base#index'
    root 'users#index'

end
