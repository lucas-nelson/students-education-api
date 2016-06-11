# models a student attending a class, completing lessons
class Student < ApplicationRecord
  validates :email, format: { with: /\A.+@.+\z/ }, length: { maximum: 255 }, presence: true, uniqueness: true
  validates :name, length: { maximum: 255 }, presence: true
end
