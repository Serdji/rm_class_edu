namespace :tag_pages do
  desc 'Load tag_pages seed'
  task load: :environment do
    puts 'Loading tag_pages'
    TagPagesService.recreate
  end
end
