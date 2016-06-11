# models a lesson comprising of a number of parts that a student can complete
class Lesson < ApplicationRecord
  validates :name, length: { maximum: 255 }, presence: true
  validates :ordinal, numericality: { greater_than: 0, only_integer: true }, presence: true
end
