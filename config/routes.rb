Rails.application.routes.draw do
  post '/scrapings', to: 'scrapings#create'
end
