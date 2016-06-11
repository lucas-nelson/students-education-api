# models a part of a lesson that a student can complete
class LessonPart < ApplicationRecord
  validates :name, length: { maximum: 255 }, presence: true
  validates :ordinal, numericality: { greater_than: 0, less_than_or_equal_to: 3, only_integer: true }, presence: true
end
