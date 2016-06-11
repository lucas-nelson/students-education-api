# models a part of a lesson that a student can complete
class LessonPart < ApplicationRecord
  has_many :completed_lesson_parts, dependent: :destroy, inverse_of: :lesson_part
  has_many :students, through: :completed_lesson_parts

  belongs_to :lesson, inverse_of: :lesson_parts, touch: true

  validates :name, length: { maximum: 255 }, presence: true
  validates :ordinal, numericality: { greater_than: 0, less_than_or_equal_to: 3, only_integer: true }, presence: true
  validates :ordinal, uniqueness: { scope: :lesson_id }
end