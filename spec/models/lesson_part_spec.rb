require 'rails_helper'

RSpec.describe LessonPart, type: :model do
  it { should respond_to :name }
  it { should validate_length_of(:name).is_at_most(255) }
  it { should validate_presence_of :name }

  it { should respond_to :ordinal }
  it { should validate_numericality_of(:ordinal).only_integer.is_greater_than(0).is_less_than_or_equal_to(3) }
  it { should validate_presence_of :ordinal }
end
