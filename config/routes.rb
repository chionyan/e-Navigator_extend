Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
   }

  root 'toppages#index'
  
  resources :interviews, only: [:index]

  resources :users, only: [:index, :show] do
    resources :interviews do
      post 'order', on: :collection
      post 'cancel', on: :collection
    end
    
    resources :messages, only: [:index, :create], param: :receiver_id do
      get 'room', on: :member
    end
    resources :messages, only: [:destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
