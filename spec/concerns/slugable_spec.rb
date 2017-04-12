RSpec.shared_examples 'slugable' do
  describe '#set_slug' do
    let(:model) { build(described_class.name.underscore, slug: slug) }

    context 'when slug exists' do
      let(:slug) { 'foo bar_baz' }

      it 'should preprocess current slug' do
        model.set_slug
        expect(model.slug).to eq 'foo-bar-baz'
      end
    end

    context 'when slug does not exist' do
      let(:slug) { nil }

      it 'should generate and preprocess new slug' do
        model.name = 'слаг_тест'
        model.set_slug
        expect(model.slug).to eq 'slag-test'
      end
    end
  end
end
