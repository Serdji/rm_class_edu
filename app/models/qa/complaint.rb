class Qa::Complaint < Qa::Base
  belongs_to :user, class_name: 'Qa::User'

  validates :comment, presence: true, on: :admin

  validates :body, presence: true, on: :front
  validates :email, presence: true, on: :front

  loggable :update

  def answer?
    complainable_type == 'Answer'
  end

  def question?
    complainable_type == 'Question'
  end

  def answer
    return unless answer?
    @answer ||= if complainable_attrs
                  Qa::Answer.new(complainable_attrs)
                else
                  Qa::Answer.find(complainable_id)
                end
  end

  def question
    return unless question?
    @question ||= if complainable_attrs
                    Qa::Question.new(complainable_attrs)
                  else
                    Qa::Question.find(complainable_id)
                  end
  end

  private

  def complainable_attrs
    complainable['attributes'].merge(id: complainable['id']) if @attributes.key? :complainable
  end
end
