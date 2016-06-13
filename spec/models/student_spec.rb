require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'validations' do
    # need to create a model here that's valid so the validate_uniqueness_of test below will work
    subject { FactoryGirl.create :student }

    it { should respond_to :email }
    it { should allow_value('a@b').for(:email) }
    it { should_not allow_value('a').for(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }

    it { should respond_to :name }
    it { should validate_length_of(:name).is_at_most(255) }
    it { should validate_presence_of :name }

    it { should respond_to :school_class }
    it { should belong_to(:school_class).dependent(false).inverse_of(:students).touch(true) }
    it { should validate_presence_of(:school_class).with_message('must exist') }
  end
end
