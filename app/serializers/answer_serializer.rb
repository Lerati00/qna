class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id
  belongs_to :author
  has_many :links
  has_many :files, serializer: FilesSerializer
  has_many :comments
end
