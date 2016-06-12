class CompletionSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id

  belongs_to :lesson_part
  belongs_to :student
end
