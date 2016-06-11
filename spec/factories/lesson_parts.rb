FactoryGirl.define do
  factory :lesson_part do
    lesson
    name "don't upset the king"
    sequence(:ordinal) { |n| n % 3 + 1 }
  end
end
