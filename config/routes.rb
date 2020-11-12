Rails.application.routes.draw do
  resources :constellations, only: [:index, :show] do
    resources :stars, only: [:index]
  end

  resources :stars, only: [:index, :show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
