require 'rails_helper'

RSpec.describe 'Teachers::TeachesStudents', type: :request do
  # index
  describe 'GET /teachers/:teacher_id/teaches_students' do
    let(:teacher) { FactoryGirl.create :teacher }
    let(:school_class) { FactoryGirl.create :school_class, teacher: teacher }
    let!(:students) { FactoryGirl.create_list :student, 5, school_class: school_class }

    it 'lists the students taught by this teacher' do
      get teacher_teaches_students_path(teacher_id: teacher)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      data = body.fetch('data')

      expect(data.size).to eq 5
      expect(data).to all(satisfy("have a 'type' attribute with a 'students' value") { |e| e['type'] == 'students' })
    end

    it 'lists the students taught by this teacher across different classes' do
      second_school_class = FactoryGirl.create :school_class, teacher: teacher
      FactoryGirl.create_list :student, 5, school_class: second_school_class

      get teacher_teaches_students_path(teacher_id: teacher)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      data = body.fetch('data')

      expect(data.size).to eq 10
      expect(data).to all(satisfy("have a 'type' attribute with a 'students' value") { |e| e['type'] == 'students' })
    end

    it 'has an empty list for a different teacher' do
      get teacher_teaches_students_path(teacher_id: FactoryGirl.create(:teacher))

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      data = body.fetch('data')

      expect(data).to be_empty
    end
  end
end
