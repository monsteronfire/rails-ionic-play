Rails.application.routes.draw do
  namespace :api do
    get 'agenda/all'
  end

  namespace :api, contraints: { format: :json } do
    get 'people', to: 'agenda#all'
  end

end
