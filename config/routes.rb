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
  get 'users/:id/search_bookmarks' => 'users#search_bookmark', as: "search_bookmark"
  patch 'users/:id/password' => 'users#password_update'
  resources :users do
  	member do
  		get :following, :followers
    end
  end
  get 'users/:id/search_bookmark' => 'users#search_bookmark_tag',as: "search_bookmark_tag"
  resources :relationships, only: [:create, :destroy]
  # post 'relationships/on_list' => 'relationships#create_on_list', as: 'relationships_on_list'
  # delete 'relationships/:id/on_list' => 'relationships#destroy_on_list', as: 'relationship_on_list'
  get 'bookmarks/:id/add' => 'bookmarks#add_bookmark',as: "add_bookmark"
  get 'works/:id/add_bookmark' => 'bookmarks#add_work_bookmark',as: "add_work_bookmark"
  delete 'works/:id/destroy_bookmark' => 'bookmarks#destroy_work_bookmark',as: "destroy_work_bookmark"
  resources :bookmarks
  resources :works
end
