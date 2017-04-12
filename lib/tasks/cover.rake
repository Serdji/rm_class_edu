namespace :cover do
  desc 'Recreate images for CarrierWave cover styles'
  task recreate: :environment do
    Book.find_each do |book|
      book.cover.image.recreate_versions! if book.cover&.image&.file
    end
  end
end
