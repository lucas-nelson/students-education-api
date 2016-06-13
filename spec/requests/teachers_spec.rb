require 'rails_helper'

RSpec.describe 'Teachers', type: :request do
  # index
  describe 'GET /teachers' do
    it 'lists all the teachers' do
      FactoryGirl.create :teacher
      FactoryGirl.create :teacher, email: 'elizabeth_hoover@example.net', name: 'Elizabeth Hoover'

      get teachers_path

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      names = body.fetch('data').map { |teacher| teacher.fetch('attributes').fetch('name') }

      expect(names).to match_array(['Edna Krabappel', 'Elizabeth Hoover'])
    end
  end

  # show
  describe 'GET /teachers/:1' do
    let(:teacher) { FactoryGirl.create :teacher }

    it 'returns the specified teacher' do
      get teacher_path(teacher)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq 'Edna Krabappel'
    end
  end

  # create
  describe 'POST /teachers' do
    it 'creates the specified teacher' do
      teacher = { data: { type: 'teachers', attributes: { email: 'elizabeth_hoover@example.net',
                                                          name: 'Elizabeth Hoover' } } }

      expect do
        post teachers_path, params: teacher.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        expect(response).to have_http_status(:created)
        expect(response.headers['Location']).to eq teacher_url(Teacher.last)

        body = JSON.parse(response.body)
        attributes = body.fetch('data').fetch('attributes')

        expect(attributes.fetch('email')).to eq 'elizabeth_hoover@example.net'
        expect(attributes.fetch('name')).to eq 'Elizabeth Hoover'
      end.to change(Teacher, :count).by 1
    end

    it 'fails to create the specific teacher with missing data' do
      teacher = { data: { type: 'teachers', attributes: { foo: 'bar' } } }

      expect do
        post teachers_path, params: teacher.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        body = JSON.parse(response.body)
        errors = body.fetch('errors')
        errors = errors.sort_by { |error| [error.dig('source', 'pointer'), error['detail']] }

        expected = [
          { 'source' => { 'pointer' => '/data/attributes/email' }, 'detail' => "can't be blank" },
          { 'source' => { 'pointer' => '/data/attributes/email' }, 'detail' => 'is invalid' },
          { 'source' => { 'pointer' => '/data/attributes/name' },  'detail' => "can't be blank" }
        ]

        expect(errors).to eql(expected)
      end.not_to change(Teacher, :count)
    end
  end

  # update
  describe 'PUT /teacher/:id' do
    it 'updates the specified teacher' do
      teacher = FactoryGirl.create :teacher

      put_teacher = { data: { type: 'teachers', id: teacher.id, attributes: { email: 'edna@example.com' } } }

      put teacher_path(teacher), params: put_teacher.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('email')).to eq 'edna@example.com'
    end
  end

  # destroy
  describe 'DELETE /teacher/:id' do
    it 'deletes the specified teacher' do
      teacher = FactoryGirl.create :teacher

      expect do
        delete teacher_path(teacher)

        expect(response).to have_http_status(:no_content)
      end.to change(Teacher, :count).by(-1)
    end
  end
end
