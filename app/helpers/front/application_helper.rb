module Front::ApplicationHelper
  # TODO: remove this later!!!
  def enqueue_if_invalid(serp_question)
    if serp_question.answers_count > 0 && serp_question.answers.count.zero?
      Rails.logger.info("Found invalid question on serp with id: #{serp_question.id}")
      SearchIndexJob.perform_later(serp_question.id, type: 'questions', event: 'update')
    end
  end

  def canonical
    path = request.env['REQUEST_PATH']
    path = path.gsub(%r{\A/page-\d+/\z}, '/')
    path = path.gsub(%r{-page-\d+/\z}, '/')
    [Settings.host, path].join
  end

  def sanitize(text, options = {})
    super(text, options).gsub(/\n/, '<br />')
  end

  def fake_link(name = nil, **attributes, &block)
    path = attributes.delete(:path)
    raise ArgumentError unless path

    attributes[:class] ||= ''
    attributes[:class] << ' _fake-link'

    attributes[:data] ||= {}
    attributes[:data][:href] = path

    if attributes.delete(:target) == :blank
      attributes[:data]['new-window'] = true
    end

    if block_given?
      content_tag(:span, attributes, &block)
    else
      content_tag(:span, name, attributes)
    end
  end
end
