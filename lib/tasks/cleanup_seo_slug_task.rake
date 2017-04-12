namespace :cleanup do
  def log_record
    print '.'
  end

  desc 'Cleanup seo and slugs'
  task seo_and_slug: :environment do
    seo_classes = [Author, Book, Metapage]
    slug_classes = [Author, Subject, Book]

    seo_classes.each do |klass|
      klass.find_each do |record|
        record.seo.destroy if record.seo && record.seo.persisted?

        record.reload.save
        log_record
      end
    end

    slug_classes.each do |klass|
      klass.find_each do |record|
        record.slug = nil
        record.set_slug!

        log_record
      end
    end
  end
end
