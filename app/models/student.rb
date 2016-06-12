# models a student attending a class, completing lessons
class Student < ApplicationRecord
  has_many :completions, dependent: :destroy, inverse_of: :student
  has_many :lesson_parts, -> { Student.order_by_lesson_ordinal }, through: :completions

  validates :email, format: { with: /\A.+@.+\z/ }, length: { maximum: 255 }, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }, presence: true

  class << self
    # Return a relation that joins each LessonPart in the 'completed'
    # association to it's Lesson so we can order by the Lesson.ordinal, and
    # then the LessonPart.ordinal.
    def order_by_lesson_ordinal
      joins('INNER JOIN "lessons" on "lessons"."id" = "lesson_parts"."lesson_id"')
        .order('"lessons"."ordinal", "lesson_parts"."ordinal"')
    end
  end
end
