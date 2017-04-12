class Front::QuestionDecorator < Draper::Decorator
  include HumanDates
  include Iso8601Dates

  decorates_association :user, with: Front::UserDecorator

  delegate_all

  delegate :name, to: :main_tag, prefix: true

  def published?
    state != 'hidden'
  end

  def human_answers_counter
    [
      answers_counter,
      Qa::Answer.model_name.human(count: answers_counter)
    ].join(' ')
  end

  def best_answer
    answers.detect(&:best_answer)
  end

  def without_best_answer
    answers.reject(&:best_answer)
  end

  def path(anchor = nil)
    h.question_path object.id, tag_slug: main_tag.slug, slug: object.slug, anchor: anchor
  rescue
    id_log(object.id)
  end

  def main_tag
    tags.first
  end

  def safe_body(length: nil, link: false, strip_tags: false, omission: '')
    result = object.body
    result = h.strip_tags(result) if strip_tags
    result = result.truncate(length, omission: omission) if length
    result = "#{result} (#{more_link})" if link && length && length < body.length
    result
  end

  # TODO: refactor
  def tags
    @tags ||= begin
      sorted_tags = taggings.sort_by(&:placement_index).map do |tagging|
        object.tags.detect { |tag| tag.id.to_i == tagging.tag_id.to_i }
      end

      sorted_tags.select(&:is_published?)
    end
  end

  def anchor
    if answers_counter.zero?
      'your-new-answer'
    elsif has_best_answer
      'best-answer'
    else
      'answers'
    end
  end

  # TODO: move this from decorator!!!
  def answers
    @answers ||= begin
      options = {
        page: { size: 500 }, include: 'user', sort: 'created_at',
        filter: { state: Qa::Answer::PUBLIC_STATES }
      }
      collection = View::Qa::Answer.get("questions/#{object.id}/answers", options)
      Front::AnswerDecorator.decorate_collection(collection)
    end
  end

  def hide_more_answers?
    answers_count = answers.size
    (best_answer && answers_count < 2) || (!best_answer && answers_count < 1)
  end

  private

  def id_log(id)
    Rails.logger.info(id)
    id.to_s
  end

  def more_link
    h.link_to('Подробнее...', path)
  end
end
