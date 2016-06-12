require 'rails_helper'

RSpec.describe LessonPart, type: :model do
  # need to create a model here that's valid so the validate_uniqueness_of test below will work
  subject { FactoryGirl.create :lesson_part }

  it { should respond_to :completions }
  it { should have_many(:completions).dependent(:destroy).inverse_of(:lesson_part) }

  it { should respond_to :lesson }
  it { should belong_to(:lesson).dependent(false).inverse_of(:lesson_parts).touch(true) }
  it { should validate_presence_of(:lesson).with_message('must exist') }

  it { should respond_to :name }
  it { should validate_length_of(:name).is_at_most(255) }
  it { should validate_presence_of :name }

  it { should respond_to :ordinal }
  it { should validate_numericality_of(:ordinal).only_integer.is_greater_than(0).is_less_than_or_equal_to(3) }
  it { should validate_presence_of :ordinal }
  it { should validate_uniqueness_of(:ordinal).scoped_to(:lesson_id) }

  it { should respond_to :students }
  it { should have_many(:students).through(:completions) }
end
