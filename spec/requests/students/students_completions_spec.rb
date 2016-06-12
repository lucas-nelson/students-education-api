require 'rails_helper'

RSpec.describe 'Students::CompletedLessonParts', type: :request do
  # create
  describe 'POST /students/:student_id/completed_lesson_parts' do
    let(:student) { FactoryGirl.create :student }
    let(:lesson_part) { FactoryGirl.create :lesson_part }

    it 'completes the lesson part for the student' do
      completed_lesson_part = { data: { type: 'lesson_parts',
                                        attributes: { lesson_part_id: lesson_part.id } } }

      expect do
        post student_completed_lesson_parts_path(student_id: student),
             params: completed_lesson_part.to_json,
             headers: { 'Content-Type': 'application/vnd.api+json' }

        expect(response).to have_http_status(:no_content)
      end.to change(Completion, :count).by 1
    end
  end

  # destroy
  describe 'DELETE /students/:student_id/completed_lesson_parts/:id' do
    let(:student) { FactoryGirl.create :student, :with_lesson_parts }

    it 'un-completes the last lesson part for the student' do
      last_completion = student.lesson_parts.last
      expect do
        delete student_completed_lesson_part_path(student_id: student, id: last_completion)

        expect(response).to have_http_status(:no_content)
      end.to change(Completion, :count).by(-1)
    end
  end

  # index
  describe 'GET /students/:student_id/completed_lesson_parts' do
    let(:student) { FactoryGirl.create :student, :with_lesson_parts }

    it 'lists the completed lession parts for the student' do
      get student_completed_lesson_parts_path(student_id: student)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').size).to eq 6
    end
  end

  # show
  describe 'GET /students/:student_id/completed_lesson_parts/:id' do
    let(:student) { FactoryGirl.create :student, :with_lesson_parts }

    it 'returns the specified completion' do
      get student_completed_lesson_part_path(student_id: student, id: student.lesson_parts.first)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq "don't upset the king"
    end
  end
end
