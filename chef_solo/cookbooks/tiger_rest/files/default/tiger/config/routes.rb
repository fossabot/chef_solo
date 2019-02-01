Rails.application.routes.draw do
  post 'job/create'
  post 'job/update'
  post 'job/check'
  get 'job/list'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
