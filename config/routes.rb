Rails.application.routes.draw do

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :lists do
      resources :cards
    end
  end

  post 'signup', to: 'users#create'
  post 'auth/login', to: 'authentication#authenticate'

end
