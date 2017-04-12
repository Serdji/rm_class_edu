class Admin::MetapageDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  # TODO: refactor
  def url(_main_page = nil)
    if metapages_type.url == '/questions_and_tags'
      return case label
               when 'Темы' then '/temy Список тем'
               when 'Ответы' then '/otvety Список ответов'
             end
    end
    metapages_type.present? ? "#{metapages_type.url} #{metapages_type.name}" : '#'
  end

  def label
    object.label.blank? ? url : object.label
  end

  alias select_name url

  private

  def grade_subject_list(url = [])
    url << grade.slug if grade
    url << subject.slug if subject
    url
  end
end
