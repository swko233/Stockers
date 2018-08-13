Rails.application.routes.draw do
    root 'root#top'
	devise_for :admins, controllers: {
	  sessions:      'admins/sessions',
	  passwords:     'admins/passwords',
	  registrations: 'admins/registrations'
	}
	devise_for :users, controllers: {
	  sessions:      'users/sessions',
	  passwords:     'users/passwords',
	  registrations: 'users/registrations'
	}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
  	member do
  		get :following, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  # post 'relationships/on_list' => 'relationships#create_on_list', as: 'relationships_on_list'
  # delete 'relationships/:id/on_list' => 'relationships#destroy_on_list', as: 'relationship_on_list'
  resources :bookmarks
end
