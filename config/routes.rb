Rails.application.routes.draw do
    resources :users
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

    get 'base', to: 'base#index'
    get 'calculate', to: 'users#calculate_data'

    root 'users#index'

end
