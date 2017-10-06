# require 'rails_helper'

# RSpec.describe Front::QuestionsController, type: :controller, integration: true do
#   context 'when logged in' do
#     let(:current_user) { create(:qa_user) }

#     before do
#       allow(controller).to receive(:current_user) { current_user }
#     end

#     describe '#create' do
#       let(:tags) { create_list(:qa_tag, 2) }
#       let(:tag_ids) { tags.map(&:id) }

#       let(:params) do
#         {
#           question: {
#             title: Faker::Lorem.sentence + rand(10000).to_s, tag_ids: tag_ids,
#             user_id: current_user.id
#           }
#         }
#       end

#       it 'should create question' do
#         post :create, params: params
#         expect(response).to have_http_status(:success)
#       end
#     end
#   end
# end
