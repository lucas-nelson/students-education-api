# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# safety valve
raise ActiveRecord::ProtectedEnvironmentError unless Rails.env.development? || ENV['DISABLE_DATABASE_ENVIRONMENT_CHECK']

# get the first N lesson parts by lesson.ordinal and lesson_part.ordinal
# this is used to set the completion for a student between 0 and 299 lesson
# parts
def random_completion
  num_lessons = rand(300)
  LessonPart.joins(:lesson).order('lessons.ordinal', 'lesson_parts.ordinal').limit(num_lessons)
end

# join some fake words together with a space and capitalize the first letter
def words(num)
  Faker::Lorem.words(num, true).join(' ').humanize
end

# lessons and lesson_parts
100.times do |idx|
  lesson_parts = Array.new(3) { |lp_idx| LessonPart.new(name: "#{lp_idx + 1}. #{words(5)}", ordinal: lp_idx + 1) }
  Lesson.create!(lesson_parts: lesson_parts, name: "#{idx + 1}. #{words(3)}", ordinal: idx + 1)
end

# students and completions
Student.create!(email: 'bart_simpson@example.net', name: 'Bart Simpson')
Student.create!(email: 'lisa_simpson@example.net', name: 'Lisa Simpson', lesson_parts: LessonPart.all)

30.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.safe_email("#{first_name}_#{last_name}")

  Student.create!(email: email, name: "#{first_name} #{last_name}", lesson_parts: random_completion)
end
