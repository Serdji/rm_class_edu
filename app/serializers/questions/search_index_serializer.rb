class Questions::SearchIndexSerializer < ActiveModel::Serializer
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :avatar_url
  end

  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :body, :user

    attribute :best_answer, key: :is_best

    attribute :modtime do
      object.updated_at.to_i
    end

    attribute :addtime do
      object.created_at.to_i
    end

    # TODO: belongs_to :user doesn't work
    def user
      UserSerializer.new(object.user).as_json
    end
  end

  attributes :id, :title, :body, :state

  attribute(:type) { 'questions' }

  attribute :answers_counter, key: :answers_count

  attribute :url do
    decorated = Front::QuestionDecorator.decorate(object)
    decorated.path
  end

  attribute :modtime do
    object.updated_at.to_i
  end

  attribute :addtime do
    object.created_at.to_i
  end

  attribute :is_published do
    object.published?
  end

  belongs_to :user, serializer: UserSerializer

  has_many :answers, serializer: AnswerSerializer do
    object.answers.select(&:published?)
  end
end
