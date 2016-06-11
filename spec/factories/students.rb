FactoryGirl.define do
  factory :student do
    email 'arya@outlook.com'
    name 'Arya Stark'

    trait :with_lesson_parts do
      after(:create) { |student| student.lesson_parts << create(:lesson_part) }
    end
  end
end
