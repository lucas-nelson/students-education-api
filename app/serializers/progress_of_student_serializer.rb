# Custom serializer to show the progress of a student.
# Want to be able to pass the details of the student, the last lesson part
# and the lesson all back at once to the client to avoid many extra API calls
class ProgressOfStudentSerializer < ActiveModel::Serializer # :nodoc:
  belongs_to :student
  belongs_to :lesson_part

  # Show the lesson details too for each part
  class LessonPartSerializer < ActiveModel::Serializer
    attributes :id, :name, :ordinal

    belongs_to :lesson
  end
end
