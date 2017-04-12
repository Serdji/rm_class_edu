namespace :migrations do
  task add_metapages: :environment do
    metapage_type = MetapagesType.create(
      name: 'Вопросы и ответы', url: '/questions_and_tags'
    )

    %w(Ответы Темы).each do |name|
      metapage_type.metapages.create(label: name)
    end
  end
end
