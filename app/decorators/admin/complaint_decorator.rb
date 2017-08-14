class Admin::ComplaintDecorator < Draper::Decorator
  include HumanDates
  LINK_REGEXP = %r{(http[s]?://|www\.)[^\s]+}

  delegate_all

  def title(is_full = true)
    if answer?
      title = h.sanitize(object.answer.body).truncate(100)
      is_full ? "Жалоба на ответ: #{title}" : title
    else
      title = h.sanitize(object.question.title)
      is_full ? "Жалоба на вопрос: #{title}" : title
    end
  end

  def body_with_links
    result = body.gsub(LINK_REGEXP) do |link|
      "<a href='#{link}' target='_blank'>#{link}</a>"
    end
    h.sanitize(result, tags: %w(a), attributes: %w(href target))
  end

  def complain_from(format_str = 'Поступила жалоба с %s')
    format_str % (answer? ? 'ответа' : 'вопроса')
  end

  def url(style = :front)
    style == :front ? front_url : admin_url
  end

  def front_url
    q = complaint_object
    anchor = answer? ? "answers-#{answer.id}" : ''
    DomainFactory.url + h.question_path(
      q,
      tag_slug: q.tags.first.slug,
      slug: q.slug,
      anchor: anchor
    )
  end

  def admin_url
    if answer?
      h.edit_admin_answer_path(answer)
    else
      h.edit_admin_question_path(question)
    end
  end

  private

  def complaint_object
    Qa::Question.find(answer? ? answer.question.id : question.id, include: 'tags')
  end
end
