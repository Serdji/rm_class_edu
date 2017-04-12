namespace :images do
  desc 'Import images from preprod (rake images:import[preprod])'
  task :import, [:stage] => :environment do |_t, args|
    args.with_defaults(stage: 'preprod')
    url = DomainFactory.url(args.stage)
    Images::Import::Local.download(Subject::Icon, url)
    Images::Import::Local.download(Images::Cover, url)
  end

  namespace :webdav do
    desc 'Import images from preprod (rake images:webdav:import[preprod,staging2])'
    task :import, [:from, :to] => :environment do |_t, args|
      # preprod => staging
      # preprod => staging2
      # staging => staging2
      # staging2 => staging
      args.with_defaults(from: 'preprod', to: 'staging2')
      to = args.to
      from = args.from
      unless %w(staging staging2).include? to
        puts "\e[0;31mCan synchronize database to staging/staging2 only\e[0;32m"
        next
      end
      if from.to_s == to.to_s
        puts "\e[0;31mCan\'t synchronize the same database\e[0;32m"
        next
      end
      Images::Import::Remote.move(Subject::Icon, from, to)
      Images::Import::Remote.move(Images::Cover, from, to)
    end
  end
end
