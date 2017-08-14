class Qa::Answer < Qa::Base
  PUBLIC_STATES = %w(fresh with_complaints without_complaints).freeze

  belongs_to :question, class_name: 'Qa::Question'
  belongs_to :user, class_name: 'Qa::User'

  has_many :complaints, class_name: 'Qa::Complaint'

  delegate :full_name, to: :user, prefix: true, allow_nil: true

  # TODO: remove hardcoded states
  scope :published, -> { where(filter: { state: %w(fresh without_complaints with_complaints) }) }

  loggable :update
  boolean_field :best_answer

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

  def link_with_images(ids)
    return unless ids.present?

    Image.where(id: ids).update_all(
      imageable_type: 'Qa::Answer', imageable_id: id, type: 'Images::Answer'
    )
  end
end
