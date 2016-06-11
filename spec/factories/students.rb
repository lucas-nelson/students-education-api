FactoryGirl.define do
  factory :student do
    email 'arya@outlook.com'
    name 'Arya Stark'

    trait :with_lesson_parts do
      transient do
        lesson_parts_count 3
      end

      after(:create) do |student, evaluator|
        create_list(:completed_lesson_part, evaluator.lesson_parts_count, student: student)
      end
    end
  end
end
