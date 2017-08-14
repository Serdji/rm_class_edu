require 'rails_helper'

RSpec.describe Front::QuestionDecorator do
  def question_decorator(body)
    Front::QuestionDecorator.new(Qa::Question.new(body: body))
  end

  describe '#safe_body' do
    it 'highlight ordinary links' do
      body = 'http://rambler.ru'
      result = '<a href="http://rambler.ru">http://rambler.ru</a>'
      expect(question_decorator(body).safe_body).to match(result)
    end
    it 'highlight ordinary links' do
      body = 'https://rambler.ru/'
      result = '<a href="https://rambler.ru/">https://rambler.ru/</a>'
      expect(question_decorator(body).safe_body).to match(result)
    end
    it 'highlight ordinary links' do
      body = 'http://rambler.ru/http://localhost/'
      result = '<a href="http://rambler.ru/http://localhost/">http://rambler.ru/http://localhost/</a>'
      expect(question_decorator(body).safe_body).to match(result)
    end
    it 'do not highlight a-links' do
      body = '<p><a href="http://rambler.ru/">http://rambler.ru/</a></p>'
      result = '<a href="http://rambler.ru/">http://rambler.ru/</a>'
      expect(question_decorator(body).safe_body).to match(result)
    end
    it 'do not highlight images' do
      body = '<p><img src="http://rambler.ru/image" /></p>'
      result = '<img src="http://rambler.ru/image">'
      expect(question_decorator(body).safe_body).to match(result)
    end
    it 'highlight link correct' do
      body = '<p>http://rambler.ru/<img src="http://rambler.ru/image" /></p>'
      result = '<a href="http://rambler.ru/">http://rambler.ru/</a><img src="http://rambler.ru/image">'
      expect(question_decorator(body).safe_body).to match(result)
    end
    it 'do not highlight images' do
      body = '<p><img src=  \'  http://rambler.ru/image     \' /></p>'
      result = '<img src="http://rambler.ru/image%20%20%20%20%20">'
      expect(question_decorator(body).safe_body).to match(result)
    end
    it 'do not highlight subdomain images' do
      body = '<p><img src="https://preprod.doctor.rambler.ru/uploads/654727d88b.jpeg"></p>'
      result = '<img src="https://preprod.doctor.rambler.ru/uploads/654727d88b.jpeg">'
      expect(question_decorator(body).safe_body).to match(result)
    end
  end
end
