class MetapagesType < ActiveRecord::Base
  has_many :metapages, dependent: :destroy

  class << self
    # TODO: change url to slug
    def library_page
      find_by(url: '/library')
    end

    # TODO: change url to slug
    def main_page
      find_by(url: 'http://class.rambler.ru/')
    end

    # TODO: change url to slug
    def qa_page
      find_by(url: '/questions_and_tags')
    end

    with_options prefix: true, allow_nil: true do |o|
      o.delegate :id, to: :library_page
      o.delegate :id, to: :main_page
      o.delegate :id, to: :qa_page
    end
  end
end
