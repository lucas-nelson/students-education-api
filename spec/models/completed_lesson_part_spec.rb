require 'rails_helper'

RSpec.describe CompletedLessonPart, type: :model do
  it { should respond_to :lesson_part }
  it { should belong_to(:lesson_part).dependent(false).inverse_of(:completed_lesson_parts) }
  it { should validate_presence_of(:lesson_part).with_message('must exist') }

  it { should respond_to :student }
  it { should belong_to(:student).dependent(false).inverse_of(:completed_lesson_parts) }
  it { should validate_presence_of(:student).with_message('must exist') }
end
