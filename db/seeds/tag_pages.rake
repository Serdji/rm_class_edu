namespace 'db:seed' do
  desc 'Load tag_pages seed'
  task 'tag_pages' do
    Rake::Task['tag_pages:load'].invoke
  end
end
