class LessonWithAssociationsSerializer < ActiveModel::Serializer # :nodoc:
  attributes :id, :name, :ordinal

  belongs_to :school_class

  has_many :lesson_parts
end
