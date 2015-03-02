Peoplespark::Application.routes.draw do
  root to: 'ideas#index'
  resources :ideas
end
