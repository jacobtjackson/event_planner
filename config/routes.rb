Rails.application.routes.draw do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    resources :events
    put '/events/:id/update_invitations', to: 'events#update_invitations', as: :update_invitations
    resources :invitations, except: :index
    resources :attendees, param: :email_address, constraints: { email_address: /.*/ }, except: %i[index create]
    resources :organizers, param: :email_address, constraints: { email_address: /.*/ }, except: %i[index create]
end
