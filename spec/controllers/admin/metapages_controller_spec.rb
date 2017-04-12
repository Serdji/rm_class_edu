require 'rails_helper'

RSpec.describe Admin::MetapagesController do
  it_behaves_like 'crudable', with: Metapage, auth: :employee, except: [:show, :new, :create, :destroy]

  let(:metapage) { create(:metapage) }

  context 'when editor use' do
    let(:editor) { create(:editor) }
    before(:each) { sign_in(editor) }

    it '#index' do
      get :index
      expect(response).to be_success
    end

    it '#edit' do
      get :edit, params: { id: metapage.id }
      expect(response).to be_forbidden
    end

    it '#update' do
      put :update, params: { id: metapage.id, metapage: attributes_for(:metapage) }
      expect(response).to be_forbidden
    end
  end
end
