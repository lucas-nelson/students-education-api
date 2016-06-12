class LessonPartSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :lesson_id, :name, :ordinal

  belongs_to :lesson

  has_many :students
end
