FactoryGirl.define do
  factory :lesson do
    name 'how not to lose your head'
    sequence(:ordinal) { |n| n }

    trait :with_lesson_parts do
      transient do
        lesson_parts_count 3
      end

      after(:create) do |lesson, evaluator|
        create_list(:lesson_part, evaluator.lesson_parts_count, lesson: lesson)
      end
    end
  end
end