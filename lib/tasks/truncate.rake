namespace :truncate do
  desc 'Remove test data from preprod database'
  task database: :environment do
    tables = %w(author_books authors books catalogs grade_books
                images pages paragraphs shops store_urls versions)
    tables.each do |table|
      ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
    end
  end
end
