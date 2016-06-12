# models the completion of a LessonPart by a Student
# for now all we need is a timestamp (and the existence of the model)
class Completion < ApplicationRecord
  belongs_to :lesson_part, inverse_of: :completions
  belongs_to :student, inverse_of: :completions
end
