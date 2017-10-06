class TagPagesService
  class << self
    def build
      mt = multi_tags.to_a
      t = tags.to_a
      results = self::Spliter.new(t).map do |from, to|
        arr = tag_hash(t, from, to)
        if (multi_tag = mt.delete_at(0))
          arr += multi_tag_hash(multi_tag)
        end
        arr
      end
      index_tag_pages(results)
    end

    def recreate
      list = build
      destroy_old(list)
      list.each do |tag|
        placement_index = tag.delete :placement_index
        t = TagPage.find_or_create_by(tag)
        t.placement_index = placement_index
        t.save
      end
    end

    private

    def index_tag_pages(results)
      results.flatten.each_with_index.map { |x, i| x.merge(placement_index: i + 1) }
    end

    def destroy_old(coll)
      m_ids = tagable_ids(coll, filter: 'Qa::MultiTag')
      t_ids = tagable_ids(coll, filter: 'Qa::Tag')

      TagPage.where(tagable_type: 'Qa::MultiTag').where.not(tagable_id: m_ids).destroy_all
      TagPage.where(tagable_type: 'Qa::Tag').where.not(tagable_id: t_ids).destroy_all
    end

    def tagable_ids(coll, filter: 'Qa::Tag')
      coll.select { |t| t[:tagable_type] == filter }.map { |t| t[:tagable_id] }
    end

    def tags
      Qa::Tag.where(has_questions: true, page: { size: 1000 }, sort: '-weight')
    end

    def multi_tags
      Qa::MultiTag.where(page: { size: 1000 }, sort: 'id')
    end

    def tag_hash(coll, from, to)
      coll[from...to].map { |q| { tagable_id: q.id, tagable_type: 'Qa::Tag' } }
    end

    def multi_tag_hash(multi_tag)
      [{ tagable_id: multi_tag.id, tagable_type: 'Qa::MultiTag' }]
    end
  end
end
