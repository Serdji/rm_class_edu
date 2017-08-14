class TagMenuBuilder < ActiveJob::Base
  queue_as :menu_builder

  def perform
    left_side = build_left_side
    right_side = build_right_side

    TagMenu.rebuild(left_side, right_side)
  end

  private

  def build_left_side
    [].tap do |result|
      Menu::Tag.ordered.pluck(:tag_id).each do |tag_id|
        tag = tag_by_id(tag_id)
        result << {
          name: tag.name, url: url_for_tag(tag),
          answers_count: tag.answers_counter,
          image_url: tag.image_url(:thumb_36x36)
        }
      end
    end
  end

  def build_right_side
    [].tap do |result|
      Menu::TagGroup.ordered.pluck(:tag_id, :tag_ids).each do |tag_id, tag_ids|
        tags = tag_ids.map do |id|
          tag = tag_by_id(id)
          { name: tag.name, url: url_for_tag(tag) }
        end

        tag = tag_by_id(tag_id)
        result << { name: tag.name, url: url_for_tag(tag), tags: tags }
      end
    end
  end

  def tag_by_id(id)
    unless @tags
      tag_ids = []

      tag_ids += Menu::Tag.pluck(:tag_id)
      tag_ids += Menu::TagGroup.pluck(:tag_id, :tag_ids).flatten

      tag_ids.uniq!

      params = {
        has_questions: true, page: { size: 200 },
        filter: { id: tag_ids, is_published: true }
      }
      @tags = View::Qa::Tag.get('tags', params).includes(:image).to_a
    end

    @tags.find { |tag| tag.id.to_i == id }
  end

  def url_for_tag(tag)
    Education::Url.tag_path(slug: tag.slug)
  end
end
