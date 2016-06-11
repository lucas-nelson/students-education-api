# models a student attending a class, completing lessons
class Student < ApplicationRecord
  has_many :completed_lesson_parts, dependent: :destroy, inverse_of: :student
  has_many :lesson_parts, through: :completed_lesson_parts

  validates :email, format: { with: /\A.+@.+\z/ }, length: { maximum: 255 }, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }, presence: true
end
