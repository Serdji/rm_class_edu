Rails.application.routes.draw do
  constraints Routing::Front do
    scope module: :front do
      scope controller: :captcha, path: :captcha do
        post :create
        post :check
      end

      resources :questions, only: [:create, :new] do
        resources :answers, only: [:create, :new], shallow: true do
          member do
            post 'make_best'
          end
        end
      end
    end

    scope module: :front, trailing_slash: true do
      root to: 'home#index', page: 1

      controller :search do
        get :resultat, action: :serp, as: :search_serp
        get 'search/suggest', action: :suggest, as: :search_suggest
      end

      get 'toggle', to: 'home#mobile_toggle'
      get 'otvety', to: redirect('/', status: 301)

      get 'tags/search/:search', to: 'tags#search', as: :search
      get 'tags/options'

      post :profile, to: 'application#profile'

      get 'temy', to: 'tags#index', page: 1
      get 'temy-page-1', to: redirect('/temy', status: 301)
      get 'temy-page-:page', to: 'tags#index'

      get 'page-1', to: redirect('/', status: 301)
      get 'page-:page', to: 'home#index'

      resources :complaints, only: :create
      get 'complaints/:complainable/:id.:format',
          to: 'complaints#new',
          as: :complaint_form,
          defaults: { format: 'htm' }

      controller :questions do
        get '/temy-:tag_slug/:slug-:id.:format',
            action: 'show',
            as: :question,
            defaults: { format: 'htm' }
        get '/:tag_slug/:slug-:id.:format',
            action: 'redirect',
            defaults: { format: 'htm' }
      end

      controller :multi_tags do
        get '/temy-multi-:slug-page-1', to: redirect('/temy-multi-%{slug}', status: 301)
        get '/temy-multi-:slug-page-:page', action: 'show'
        get '/temy-multi-:slug', action: 'show', as: :multi_tag, page: 1
      end

      controller :tags do
        get '/temy-:slug-page-1', to: redirect('/temy-%{slug}', status: 301)
        get '/temy-:slug-page-:page', action: 'show'
        get '/temy-:slug', action: 'show', as: :tag, page: 1
      end
    end
  end
end
