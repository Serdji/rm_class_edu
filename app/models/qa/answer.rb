class Qa::Answer
  PUBLIC_STATES = %w(fresh with_complaints without_complaints).freeze

  include Her::JsonApi::Model

  include Qa::Datable
  include Qa::Relationable
  include Qa::Errorable

  belongs_to :question, class_name: 'Qa::Question'
  belongs_to :user, class_name: 'Qa::User'

  has_many :complaints, class_name: 'Qa::Complaint'

  delegate :full_name, to: :user, prefix: true, allow_nil: true

  # TODO: remove hardcoded states
  scope :published, -> { where(filter: { state: %w(fresh without_complaints with_complaints) }) }

  class << self
    def states_for_select
      I18n.t('states.answer').invert.to_a
    end
  end

  def make_best!
    Qa::Answer.post_resource("answers/#{id}/make_best") if id
  end

  # TODO: move from this
  def as_json(attributes = {})
    attrs = super(attributes)['attributes']

    attrs.slice('id', 'body').merge(
      username: user.full_name,
      user_avatar_url: user.avatar_url,
      created_at: I18n.l(created_at.in_time_zone, format: :answer)
    )
  end
end
