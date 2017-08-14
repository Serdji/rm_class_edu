require 'rails_helper'

RSpec.describe Admin::EmployeesController do

  let(:employee) { create(:employee) }
  let(:role) { create(:role) }

  context 'when superuser use' do
    before(:each) { sign_in(employee) }

    it '#index' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it '#new' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it '#create' do
      post :create, params: { employee: attributes_for(:employee, role_id: role.id) }
      expect(response).to have_http_status(:redirect)
    end

    it '#edit' do
      get :edit, params: { id: employee.id }
      expect(response).to have_http_status(:success)
    end

    it '#update' do
      put :update, params: { id: employee.id, employee: attributes_for(:employee, role_id: role.id) }
      expect(response).to have_http_status(:redirect)
    end

    it '#destroy' do
      delete :destroy, params: { id: employee.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe '#update' do
    context 'is failed' do
      before(:each) { sign_in(employee) }

      it 'render edit again' do
        put :update, params: { id: employee, employee: attributes_for(:employee, first_name: '') }
        expect(response).to render_template('edit')
      end
    end
  end

  context 'when editor use' do
    let(:editor) { create(:editor) }
    before(:each) { sign_in(editor) }

    it '#index' do
      get :index
      expect(response).to be_forbidden
    end

    it '#new' do
      get :new
      expect(response).to be_forbidden
    end

    it '#create' do
      post :create, params: { employee: attributes_for(:employee) }
      expect(response).to be_forbidden
    end

    it '#edit' do
      get :edit, params: { id: employee.id }
      expect(response).to be_forbidden
    end

    it '#update' do
      put :update, params: { id: employee.id, employee: attributes_for(:employee) }
      expect(response).to be_forbidden
    end

    it '#destroy' do
      delete :destroy, params: { id: employee.id }
      expect(response).to be_forbidden
    end
  end
end
