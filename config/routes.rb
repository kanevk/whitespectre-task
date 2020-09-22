Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope 'users/:user_id' do
    resources :group_events do
      resource :publish, on: :member, controller: 'published_group_events', only: %i(create destroy)
    end
  end
end
