require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'validations' do
    it { should respond_to :name }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_presence_of :name }

    it { should respond_to :ordinal }
    it { should validate_numericality_of(:ordinal).only_integer.is_greater_than(0) }
    it { should validate_presence_of :ordinal }
  end
end
