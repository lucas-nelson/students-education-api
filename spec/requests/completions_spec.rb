require 'rails_helper'

RSpec.describe 'Completions', type: :request do
  # destroy
  describe 'DELETE /completions/:id' do
    let(:student) { FactoryGirl.create :student, :with_lesson_parts }

    it 'un-completes the last lesson part for the student' do
      last_completion = student.completions.last
      expect do
        delete completion_path(id: last_completion)

        expect(response).to have_http_status(:no_content)
      end.to change(Completion, :count).by(-1)
    end
  end

  # show
  describe 'GET /completions/:id' do
    let(:completion) { FactoryGirl.create :completion }

    it 'returns the specified completion' do
      get completion_path(completion)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      relationships = body.fetch('data').fetch('relationships')

      expect(relationships.fetch('lesson-part')).to include('data')
      expect(relationships.fetch('student')).to include('data')
    end
  end
end
