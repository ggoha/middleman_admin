Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "files#index"
  resources :files, constraints: { :id => /[^\/]+/ } do
    post 'replace', on: :collection
    post 'build', on: :collection
  end
end
