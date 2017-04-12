require 'supports/shared/admin/crudable_arguments'

RSpec.shared_examples 'crudable' do |args|
  args = CrudableArguments.new(args)

  render_views

  if args.authenticate?
    let(args.auth_model) { create(args.auth_model) }
    before(:each) { sign_in(send(args.auth_model)) }
  end

  describe 'GET #index' do
    let(:count) { 5 }
    before { create_list(args.singular_name, count) }

    it "should return list of #{args.plural_name}" do
      get :index

      expect(response).to have_http_status(:success)
      expect(assigns(args.plural_name).length).to \
        eq args.singular_name.to_sym == args.args['auth'] ? count + 1 : count
    end
  end if args.actions.include?(:index)

  describe 'GET #new' do
    it "should instantiate #{args.singular_name}" do
      get :new
      expect(assigns(args.singular_name)).to be_a args.resource
      expect(assigns(args.singular_name).persisted?).to be_falsey
    end
  end if args.actions.include?(:new)

  describe 'POST #create' do
    let(:params) do
      if respond_to? "extra_params_#{args.singular_name}"
        attributes_for(args.singular_name).merge(send("extra_params_#{args.singular_name}"))
      else
        attributes_for(args.singular_name)
      end
    end

    it "should create #{args.singular_name}" do
      post :create, params: { args.singular_name => params }

      expect(response).to have_http_status(:redirect)
      expect(assigns(args.singular_name).persisted?).to be_truthy
    end
  end if args.actions.include?(:create)

  describe 'GET #show' do
    let(args.singular_name) { create(args.singular_name) }

    it "should show #{args.singular_name}" do
      get :show, params: { id: send(args.singular_name) }

      expect(response).to have_http_status(:success)
      expect(assigns(singular_name).persisted?).to be_truthy
    end
  end if args.actions.include?(:show)

  describe 'GET #edit' do
    let(args.singular_name) { create(args.singular_name) }

    it "should allow to edit #{args.singular_name}" do
      get :edit, params: { id: send(args.singular_name) }

      expect(response).to have_http_status(:success)
      expect(assigns(args.singular_name).persisted?).to be_truthy
    end
  end if args.actions.include?(:edit)

  describe 'PATCH/PUT #update' do
    let(args.singular_name) { create(args.singular_name) }
    let(:attributes) { attributes_for(args.singular_name) }

    it "should update #{args.singular_name}" do
      put :update, params: { id: send(args.singular_name), args.singular_name => attributes }

      expect(response).to have_http_status(:redirect)
      expect(send(args.singular_name).errors.count).to be_zero
    end
  end if args.actions.include?(:update)

  describe 'DELETE #destroy' do
    let!(args.singular_name) { create(args.singular_name) }

    it "should delete #{args.singular_name}" do
      expect(args.resource.count).to eq 1
      delete :destroy, params: { id: send(args.singular_name) }
      expect(args.resource.count).to be_zero
    end
  end if args.actions.include?(:destroy)
end
