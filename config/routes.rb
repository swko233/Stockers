Rails.application.routes.draw do
  get 'work_bookmarks/new'
  get 'work_bookmarks/edit'
  get 'bookmarks/new'
  get 'bookmarks/edit'
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

  resources :users
end
