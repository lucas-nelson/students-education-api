FactoryGirl.define do
  factory :student do
    email 'arya@outlook.com'
    name 'Arya Stark'

    trait :with_lesson_parts do
      transient do
        # how many groups of 3 completed lesson parts should be created?
        lesson_parts_groups_count 2
      end

      after(:create) do |student, evaluator|
        # this is more complicated than a straight `create_list` so we can get
        # the same lesson reference in each group of three lesson parts
        evaluator.lesson_parts_groups_count.times do
          lesson = create(:lesson)
          3.times do |idx|
            # count the ordinal down here to help test the relation ordering
            student.lesson_parts << create(:lesson_part, lesson: lesson, ordinal: 3 - idx)
          end
        end
      end
    end
  end
end
