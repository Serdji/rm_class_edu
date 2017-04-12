Rails.application.routes.draw do
  constraints Routing::Front do
    scope module: :front, trailing_slash: true do
      root to: 'home#index', page: 1

      controller :search do
        get :resultat, action: :serp, as: :search_serp
        get 'search/suggest', action: :suggest, as: :search_suggest
      end

      get 'toggle', to: 'home#mobile_toggle'
      get 'otvety', to: redirect('/', status: 302)

      resources :questions, only: :create do
        resources :answers, only: :create, shallow: true do
          member do
            post 'make_best'
          end
        end
      end

      get 'tags/search/:search', to: 'tags#search', as: :search
      get 'tags/options'

      post 'users/question', to: 'users#question_create'
      get 'users/question', to: 'users#question_show'
      post 'users/question/clear', to: 'users#question_clear'

      post :profile, to: 'application#profile'

      get 'temy', to: 'tags#index', page: 1
      get 'temy-page-1', to: redirect('/temy', status: 302)
      get 'temy-page-:page', to: 'tags#index'

      get 'page-1', to: redirect('/', status: 302)
      get 'page-:page', to: 'home#index'

      resources :complaints, only: :create

      controller :questions do
        get '/:tag_slug/:slug-:id.:format', action: 'show', as: :question, defaults: { format: 'htm' }
      end

      controller :tags do
        get '/temy-:slug-page-1', to: redirect('/temy-%{slug}', status: 302)
        get '/temy-:slug-page-:page', action: 'show'
        get '/temy-:slug', action: 'show', as: :tag, page: 1
      end
    end
  end
end
