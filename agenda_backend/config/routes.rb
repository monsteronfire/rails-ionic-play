Rails.application.routes.draw do
  namespace :api do
    get 'agenda/all'
  end

  namespace :api, constraints: { format: :json } do
    get 'people', to: 'agenda#all'
  end

  # root 'ember#bootstrap'
  # get '/*path', to: 'ember#bootstrap'

end
