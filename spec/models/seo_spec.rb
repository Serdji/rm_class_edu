require 'rails_helper'

RSpec.describe Seo do
  let(:seo) {
    build(:seo, title: title, description: description)
  }

  describe '#cut_fields' do
    context 'title' do
      let(:title) { Faker::Lorem.words(50).join(' ') }
      let(:description) { Faker::Lorem.word }

      context 'when length more than 250' do
        it 'should cut title length' do
          expect(seo.title.length).to be > Seo::TITLE_MAX_LENGTH
          seo.save
          expect(seo.reload.title.length).to be <= Seo::TITLE_MAX_LENGTH
        end
      end
    end

    context 'description' do
      let(:description) { Faker::Lorem.words(50).join(' ') }
      let(:title) { Faker::Lorem.word }

      context 'when length more than 200' do
        it 'should cut description length' do
          expect(seo.description.length).to be > Seo::DESCRIPTION_MAX_LENGTH
          seo.save
          expect(seo.reload.description.length).to be <= Seo::DESCRIPTION_MAX_LENGTH
        end
      end
    end

    context 'nonspaces words' do
      let(:description) { Faker::Lorem.words(250).join('') }
      let(:title) { Faker::Lorem.words(250).join('') }

      context 'when title length more than 250 and description more than 200' do
        it 'should cut title length' do
          expect(seo.title.length).to be > Seo::TITLE_MAX_LENGTH
          expect(seo.description.length).to be > Seo::DESCRIPTION_MAX_LENGTH
          seo.save
          expect(seo.reload.title.length).to be <= Seo::TITLE_MAX_LENGTH
          expect(seo.reload.description.length).to be <= Seo::DESCRIPTION_MAX_LENGTH
        end
      end
    end
  end
end
