class TagPage < ActiveRecord::Base
  attr_accessor :tagable

  class << self
    def qa_build
      coll = all
      m = multi_tags(coll)
      t = tags(coll)
      0.upto(coll.length - 1) do |i|
        coll[i].tagable = tagable(coll[i].multi_tag? ? m : t, coll[i].tagable_id)
      end
      coll
    end

    private

    def tagable(source, id)
      source.find { |x| x.id == id }
    end

    def tags(coll)
      tag_ids = coll.select { |x| x.tagable_type == 'Qa::Tag' }.map(&:tagable_id)
      return [] if tag_ids.size.zero?
      options = {
        has_questions: true, sort: '-weight',
        filter: { id: tag_ids }, page: { size: tag_ids.size }
      }
      View::Qa::Tag.get('tags', options).includes(:seo, :image)
    end

    def multi_tags(coll)
      multi_tag_ids = coll.select { |x| x.tagable_type == 'Qa::MultiTag' }.map(&:tagable_id)
      return [] if multi_tag_ids.size.zero?
      options = {
        sort: 'id', include: 'tags',
        filter: { id: multi_tag_ids }, page: { size: multi_tag_ids.size }
      }
      View::Qa::MultiTag.get('multi_tags', options).includes(:seo)
    end
  end

  def multi_tag?
    tagable_type == 'Qa::MultiTag'
  end
end
