require 'rails_helper'

RSpec.describe SchoolClass, type: :model do
  it { should respond_to :name }
  it { should validate_length_of(:name).is_at_most(255) }
  it { should validate_presence_of :name }

  it { should respond_to :teacher }
  it { should belong_to(:teacher).dependent(false).inverse_of(:school_classes).touch(true) }
  it { should validate_presence_of(:teacher).with_message('must exist') }
end
