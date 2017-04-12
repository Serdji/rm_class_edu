require 'rails_helper'

RSpec.describe Front::ApplicationHelper do
  MONTHES = %w(месяцы января февраля марта апреля мая
               июня июля августа сентября октября ноября декабря).freeze

  describe 'should retrun corret format' do
    let(:today) { Time.zone.today }
    let(:yesterday) { Time.zone.yesterday }
    let(:before_yesterday) { Time.zone.today - 1.day - 1.hour }
    let(:last_year) { Time.zone.today - 1.year - 1.hour }

    it 'when date is today' do
      expect(qa_datetime_format(today)).to eq(today.strftime('Сегодня, %H:%M'))
    end
    it 'when date is yesterday' do
      expect(qa_datetime_format(yesterday)).to eq(yesterday.strftime('Вчера, %H:%M'))
    end
    it 'when date is before yesterday' do
      result = "#{before_yesterday.strftime('%-e')} " \
               "#{MONTHES[before_yesterday.strftime('%-m').to_i]}"
      expect(qa_datetime_format(before_yesterday)).to eq(result)
    end
    it 'when date is last year' do
      result = "#{last_year.strftime('%-e')} " \
               "#{MONTHES[before_yesterday.strftime('%-m').to_i]} " \
               "#{last_year.strftime('%Y')}"
      expect(qa_datetime_format(last_year)).to eq(result)
    end
  end
end
