class LessonPartSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :lesson_id, :name, :ordinal
end
