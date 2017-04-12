FactoryGirl.define do
  factory :image do
    factory :cover, class: Images::Cover do
      # image { Rails.root.join('spec/fixtures/images/geometry.jpg').open }
      association :imageable, factory: :book, type: 'Textbook'
    end

    factory :icon, class: Subject::Icon do
      image do
        path = Rails.root.join('db/data/icons/chemistry.png')
        Rack::Test::UploadedFile.new(path, 'image/png')
      end
    end
  end
end
