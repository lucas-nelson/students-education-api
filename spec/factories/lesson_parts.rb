FactoryGirl.define do
  factory :lesson_part do
    lesson
    name "don't upset the king"
    sequence(:ordinal) { |n| n % 3 + 1 }

    trait :with_students do
      after(:create) { |lesson_part| lesson_part.students << create(:student) }
    end
  end
end
