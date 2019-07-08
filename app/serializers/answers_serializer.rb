class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id
  belongs_to :author
end
