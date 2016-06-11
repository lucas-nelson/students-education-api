class CompletedLessonPartSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id
  has_one :lesson_part
  has_one :student
end
