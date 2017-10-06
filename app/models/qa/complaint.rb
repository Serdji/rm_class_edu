class Qa::Complaint < Qa::Base
  belongs_to :user, class_name: 'Qa::User'

  validates :comment, presence: true, on: :admin

  validates :body, presence: true, on: :front

  loggable :update

  def answer?
    complainable_type == 'Answer'
  end

  def question?
    complainable_type == 'Question'
  end

  def answer
    return unless answer?
    @answer ||= if has_complainable?
                  Qa::Answer.new(complainable)
                else
                  Qa::Answer.find(complainable_id)
                end
  end

  def question
    return unless question?
    @question ||= if has_complainable?
                    Qa::Question.new(complainable)
                  else
                    Qa::Question.find(complainable_id)
                  end
  end

  private

  def has_complainable?
    @attributes.key? :complainable
  end
end
