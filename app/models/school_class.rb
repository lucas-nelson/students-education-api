# models a class in school having a teachers, students and lessons
class SchoolClass < ApplicationRecord
  belongs_to :teacher, inverse_of: :school_classes, touch: true

  validates :name, length: { maximum: 255 }, presence: true
end
