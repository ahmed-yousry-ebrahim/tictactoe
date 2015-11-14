Rails.application.routes.draw do


  resources :games do
    resources :rounds do
      member do
        post :calculate_result
      end
    end
  end

  resources :players

  root 'games#new'
end
