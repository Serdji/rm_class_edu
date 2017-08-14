namespace :search do
  namespace :index do
    def with_log(type)
      print "Indexing #{type}... "
      yield
      puts "\e[32m✓\e[0m"
    end

    def with_each_page(collection)
      Array(1..collection.total_pages).each do |page|
        yield page
      end
    end

    desc 'Reindex questions'
    task questions: :environment do
      with_log(:questions) do
        with_each_page(View::Qa::Question.published) do |page|
          questions = View::Qa::Question.published(page: { number: page })
          questions.each do |question|
            SearchIndexJob.perform(question.id, type: 'questions', event: 'update')
          end
        end
      end
    end

    desc 'Reindex tags'
    task tags: :environment do
      with_log(:tags) do
        with_each_page(View::Qa::Tag.published) do |page|
          tags = View::Qa::Tag.published(page: { number: page })
          tags.each do |tag|
            SearchIndexJob.perform(tag.id, type: 'tags', event: 'update')
          end
        end
      end
    end

    desc 'Reindex questions and tags'
    task all: [:questions, :tags]
  end
end
