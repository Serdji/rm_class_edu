class Front::AnswerDecorator < Draper::Decorator
  include Iso8601Dates
  include Linkable
  include Avatarable

  delegate :full_name, to: :user, prefix: true, allow_nil: true

  delegate_all

  def safe_body
    sanitized = h.sanitize(body)
    link_highlight(sanitized)
  end
end
