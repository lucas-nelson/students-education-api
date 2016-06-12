require 'rails_helper'

RSpec.describe 'StudentsCompletions', type: :request do
  # create
  describe 'POST /students/:student_id/completions' do
    let(:student) { FactoryGirl.create :student }
    let(:lesson_part) { FactoryGirl.create :lesson_part }

    it 'completes the lesson part for the student' do
      completion = { data: { type: 'completions',
                             attributes: { lesson_part_id: lesson_part.id } } }

      expect do
        post student_completions_path(student_id: student),
             params: completion.to_json,
             headers: { 'Content-Type': 'application/vnd.api+json' }

        expect(response).to have_http_status(:no_content)
      end.to change(Completion, :count).by 1
    end
  end

  # index
  describe 'GET /students/:student_id/completions' do
    let(:student) { FactoryGirl.create :student, :with_lesson_parts }

    it 'lists the completed lession parts for the student' do
      get student_completions_path(student_id: student)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').size).to eq 6
    end
  end
end
