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

  describe 'listing students' do
    let(:teacher) { FactoryGirl.create :teacher }
    let(:school_class) { FactoryGirl.create :school_class, teacher: teacher }
    let!(:students) { FactoryGirl.create_list :student, 5, school_class: school_class }

    it 'lists all the students taught by the a teacher' do
      taught_by = Student.taught_by teacher

      expect(taught_by.size).to eq 5
    end

    it 'lists all the students taught by the a teacher across different classes' do
      second_school_class = FactoryGirl.create :school_class, teacher: teacher
      FactoryGirl.create_list :student, 5, school_class: second_school_class

      taught_by = Student.taught_by teacher

      expect(taught_by.size).to eq 10
    end

    it 'does not list students taught by a different teacher' do
      teacher = FactoryGirl.create :teacher

      taught_by = Student.taught_by teacher

      expect(taught_by).to be_empty
    end
  end
end
