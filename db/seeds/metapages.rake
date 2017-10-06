namespace 'db:seed' do
  def subject_grade(subject, grade, sepatator = ' ')
    result = []
    result << subject.name if subject
    result << "#{grade.grade} класс" if grade
    result.join(sepatator)
  end

  desc 'Load metapages seed'
  task :metapages do
    puts 'Loading metapages'
    Metapage.destroy_all
    MetapagesType.destroy_all
    types = [
      { name: 'Главная', url: 'http://class.rambler.ru/' }
      # { name: 'Библиотека', url: '/library' }
    ]

    MetapagesType.create types
    # type = MetapagesType.find_by(name: 'Библиотека')

    metapages = []
    # metapages = Front::GradeSubjectQuery.collect do |grade, subject|
    #   {
    #     label: "Страница библиотеки #{subject_grade(subject, grade)}",
    #     title: subject_grade(subject, grade),
    #     description: "Описание страницы библиотеки #{subject_grade(subject, grade)}",
    #     grade_id: grade&.id,
    #     subject_id: subject&.id,
    #     metapages_type_id: type&.id,
    #     seo_attributes: {
    #       title: "Рамбер/класс - #{subject_grade(subject, grade)}",
    #       keywords: "учебники, #{subject_grade(subject, grade, ', ')}",
    #       description: "META-описание для страницы учебников #{subject_grade(subject, grade)}"
    #     }
    #   }
    # end

    MetapagesType.all.each do |t|
      metapages << {
        label: t&.name,
        title: t&.name,
        description: t&.name,
        metapages_type_id: t&.id,
        seo_attributes: {}
      }
    end
    Metapage.create metapages

    # QA Service
    metapage_type = MetapagesType.create(
      name: 'Вопросы и ответы', url: '/questions_and_tags'
    )

    %w(Ответы Темы).each do |name|
      metapage_type.metapages.create(label: name)
    end
  end
end
