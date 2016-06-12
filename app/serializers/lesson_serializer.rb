class LessonSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :name, :ordinal

  has_many :lesson_parts
end
