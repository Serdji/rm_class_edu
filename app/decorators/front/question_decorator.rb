class Front::QuestionDecorator < Draper::Decorator
  include HumanDates
  include Iso8601Dates
  include Linkable
  include Avatarable

  LINES = 3

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

  def path(anchor: false, anchor_name: nil, hash_id: nil)
    h.question_path(
      object.id,
      tag_slug: main_tag.slug,
      slug: object.slug,
      anchor: (anchor ? anchor_name || answers_anchor : nil),
      hash_id: hash_id
    )
  rescue => e
    path_logger(id, e)
  end

  def mobile_path
    if answers_counter.positive?
      path(hash_id: has_best_answer ? 'best-answer' : 'answers')
    else
      h.new_question_answer_path(question_id: id)
    end
  end

  def main_tag
    tags.first
  end

  def safe_body(length: nil, link: false, strip_tags: false, omission: '')
    result, more = sanitize_with_br(length, strip_tags)
    result = result.truncate(length, omission: omission, separator: %r{\s(?!/)}) if length
    result = link_highlight(result) unless length || strip_tags
    if link && more
      "#{result} (#{more_link})"
    else
      result
    end
  end

  def tags
    @tags ||= object.tags.select(&:is_published?)
  end

  # TODO: move this from decorator!!!
  def answers
    @answers ||= begin
      options = {
        page: { size: 500 }, include: 'user', sort: 'answers.created_at',
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

  def answers_anchor
    if answers_counter.zero?
      'your-new-answer'
    elsif has_best_answer
      'best-answer'
    else
      'answers'
    end
  end

  def sanitize_with_br(length, strip_tags)
    more = length && length < body.length
    if strip_tags
      lines = h.sanitize(body, tags: ['br'], attributes: []).split(%r{<br[ /]*>})
      [lines[0, LINES].join('<br />'), more || lines.count > LINES]
    else
      [h.sanitize(body), more]
    end
  end

  def path_logger(id, e)
    Rails.logger.info(format('Building question (%s) path with error: %s', id, e))
    Rails.logger.info(e.backtrace.join("\n"))
    id.to_s
  end

  def more_link
    h.link_to('Подробнее...', path)
  end
end
