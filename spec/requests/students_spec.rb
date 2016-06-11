require 'rails_helper'

RSpec.describe 'Students', type: :request do
  # index
  describe 'GET /students' do
    it 'lists all the students' do
      FactoryGirl.create :student
      FactoryGirl.create :student, email: 'sansa@hotmail.com', name: 'Sansa Stark'

      get students_path

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      names = body.fetch('data').map { |student| student.fetch('attributes').fetch('name') }

      expect(names).to match_array(['Arya Stark', 'Sansa Stark'])
    end
  end

  # show
  describe 'GET /students/:1' do
    let(:student) { FactoryGirl.create :student }

    it 'returns the specified student' do
      get student_path(student)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq 'Arya Stark'
    end

    it 'includes completed lesson parts in order' do
      get student_path(FactoryGirl.create(:student, :with_lesson_parts))

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('included').select { |i| i.fetch('type') == 'lesson-parts' }.size).to eq 6
      expect(body.fetch('included').map { |i| i.fetch('attributes').fetch('ordinal') }).to eql([1, 2, 3, 1, 2, 3])
    end
  end

  # create
  describe 'POST /students' do
    it 'creates the specified student' do
      student = { data: { type: 'students', attributes: { email: 'sansa@hotmail.com', name: 'Sansa Stark' } } }

      expect do
        post students_path, params: student.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        expect(response).to have_http_status(:created)
        expect(response.headers['Location']).to eq student_url(Student.last)

        body = JSON.parse(response.body)
        attributes = body.fetch('data').fetch('attributes')

        expect(attributes.fetch('email')).to eq 'sansa@hotmail.com'
        expect(attributes.fetch('name')).to eq 'Sansa Stark'
      end.to change(Student, :count).by 1
    end

    it 'fails to create the specific student with missing data' do
      student = { data: { type: 'students', attributes: { foo: 'bar' } } }

      expect do
        post students_path, params: student.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        body = JSON.parse(response.body)
        errors = body.fetch('errors')
        errors = errors.sort_by { |error| [error.dig('source', 'pointer'), error['detail']] }

        expected = [
          { 'source' => { 'pointer' => '/data/attributes/email' }, 'detail' => "can't be blank" },
          { 'source' => { 'pointer' => '/data/attributes/email' }, 'detail' => 'is invalid' },
          { 'source' => { 'pointer' => '/data/attributes/name' },  'detail' => "can't be blank" }
        ]

        expect(errors).to eql(expected)
      end.not_to change(Student, :count)
    end
  end

  # update
  describe 'PUT /student/:id' do
    it 'updates the specified student' do
      student = FactoryGirl.create :student

      put_student = { data: { type: 'students', id: student.id, attributes: { email: 'arya2@outlook.com' } } }

      put student_path(student), params: put_student.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('email')).to eq 'arya2@outlook.com'
    end
  end

  # destroy
  describe 'DELETE /student/:id' do
    it 'deletes the specified student' do
      student = FactoryGirl.create :student

      expect do
        delete student_path(student)

        expect(response).to have_http_status(:no_content)
      end.to change(Student, :count).by(-1)
    end

    it 'deletes completed lesson parts too' do
      student = FactoryGirl.create :student, :with_lesson_parts

      expect do
        delete student_path(student)

        expect(response).to have_http_status(:no_content)
      end.to change(CompletedLessonPart, :count).by(-6)
    end
  end
end
