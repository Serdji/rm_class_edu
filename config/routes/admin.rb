require 'resque/server'

class ResqueWeb < Resque::Server
  use Rack::Session::Cookie, key: 'rack.session', secret: ENV['SECRET_KEY_BASE']
end

class ResqueServerFactory
  class << self
    def server
      new.server
    end
  end

  def initialize
    @server = ['development', 'test'].include?(Rails.env) ? Resque::Server : ResqueWeb
  end

  def server
    @server.new
  end
end

Rails.application.routes.draw do
  concern :pageable do
    collection { get 'page/:page', action: :index, page: /\d+/ }
  end

  get :authenticity_token, to: 'application#authenticity_token'
  post :upload_image, to: 'application#upload_image'

  constraints Routing::Admin do
    root to: redirect('/admin/login') if Routing::Admin.present?

    namespace :admin do
      resque_constraints = lambda do |request|
        request.env['warden'].authenticate? && request.env['warden'].user.has_role?(:superuser)
      end

      constraints(resque_constraints) do
        mount ResqueServerFactory.server, at: '/resque', as: :queues
      end

      devise_options = {
        skip: :sessions,
        singular: :employee
      }
      devise_for :employees, devise_options

      devise_scope :employee do
        get    'login',  to: 'sessions#new'
        post   'login',  to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
      end

      with_options except: :show do |o|
        o.resources :employees

        o.resources :questions, except: [:new, :create, :destroy] do
          member do
            get 'complaints', to: 'questions#complaints'
          end
        end
        o.resources :answers, except: [:new, :create, :destroy] do
          member do
            get 'complaints', to: 'answers#complaints'
          end
        end

        o.resources :tags, except: :destroy do
          collection do
            get 'search/:search', action: :search, as: :search
          end
        end

        o.resources :complaints, only: [:index, :edit, :update]
        o.resources :users, only: [:index, :edit, :update]
      end

      root to: 'questions#index', as: :root

      resources :metapages, only: [:index, :edit, :update], concerns: :pageable
      resources :versions, only: [:index, :show], concerns: :pageable

      scope :settings, module: :settings do
        get :edit, as: :settings_edit
        post :update, as: :settings_update
      end

      resources :seo, only: [:create, :update, :destroy]
      resources :seo_links, except: [:new, :show, :edit]

      if Rails.env.development?
        match 'webdav_mock', to: 'webdav_mock#create', via: :put
      end
    end
  end
end
