require 'rails_helper'

RSpec.shared_examples 'imagable' do |*args|
  IMAGE_ID_PATTERN = /:data-id=['"](?<id>\d+)['"]/

  factory = described_class.name.underscore

  let(:model) { create(factory, attributes).reload }
  let(:file_path) { Rails.root.join('public/tmp/geometry.jpg') }
  let(:url) { "http://webdav01.park.rambler.ru/tmp/geometry.jpg" }

  let(:attributes) do
    attrs = args.map { |field| [field.to_sym, "![ALT-image](#{url}){:data-id=\"0\"}"] }.to_h
    attributes_for(factory, attrs)
  end

  before do
    source = Rails.root.join('spec/fixtures/images/geometry.jpg')

    FileUtils.mkdir_p(Rails.root.join('public/tmp'))
    FileUtils.cp(source, file_path)

    stub_request(:get, /webdav01.park.rambler.ru/).to_return(body: File.read(file_path))
  end

  after do
    FileUtils.rm_f(file_path)
  end

  context 'when save' do
    it 'should replace data-id for image' do
      args.each do |field|
        image_id = model.send(field).match(IMAGE_ID_PATTERN)[:id]
        expect(image_id.to_i).to be > 0
      end
    end

    it 'should replace tmp url with actual' do
      args.each do |field|
        content = model.send(field)
        image_id = content.match(IMAGE_ID_PATTERN)[:id]
        image = Image.find(image_id.to_i)
        expect(content.include?(image.image_url))
      end
    end
  end
end
