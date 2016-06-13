require 'rails_helper'

RSpec.describe 'SchoolClasses', type: :request do
  # index
  describe 'GET /school_classes' do
    it 'lists all the school classes' do
      first = FactoryGirl.create :school_class
      FactoryGirl.create :school_class, name: '1B', teacher_id: first.teacher.id

      get school_classes_path

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      names = body.fetch('data').map { |school_class| school_class.fetch('attributes').fetch('name') }

      expect(names).to match_array(['Kindergarten (KJ)', '1B'])
    end
  end

  # show
  describe 'GET /school_classes/:1' do
    let(:school_class) { FactoryGirl.create :school_class }

    it 'returns the specified school_class' do
      get school_class_path(school_class)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq 'Kindergarten (KJ)'
    end
  end

  # create
  describe 'POST /school_classes' do
    it 'creates the specified school_class' do
      teacher = FactoryGirl.create :teacher
      school_class = { data: { type: 'school_classes', attributes: { name: '1B', teacher_id: teacher.id } } }

      expect do
        post school_classes_path, params: school_class.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        expect(response).to have_http_status(:created)
        expect(response.headers['Location']).to eq school_class_url(SchoolClass.last)

        body = JSON.parse(response.body)
        attributes = body.fetch('data').fetch('attributes')
        relationships = body.fetch('data').fetch('relationships')

        expect(attributes.fetch('name')).to eq '1B'
        expect(relationships.fetch('teacher').fetch('data').fetch('id')).to eq teacher.id.to_s
      end.to change(SchoolClass, :count).by 1
    end

    it 'fails to create the specific school_class with missing data' do
      school_class = { data: { type: 'school_classes', attributes: { foo: 'bar' } } }

      expect do
        post school_classes_path, params: school_class.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        body = JSON.parse(response.body)
        errors = body.fetch('errors')
        errors = errors.sort_by { |error| [error.dig('source', 'pointer'), error['detail']] }

        expected = [
          { 'source' => { 'pointer' => '/data/attributes/name' },    'detail' => "can't be blank" },
          { 'source' => { 'pointer' => '/data/attributes/teacher' }, 'detail' => 'must exist' }
        ]

        expect(errors).to eql(expected)
      end.not_to change(SchoolClass, :count)
    end
  end

  # update
  describe 'PUT /school_class/:id' do
    it 'updates the specified school_class' do
      school_class = FactoryGirl.create :school_class

      put_school_class = { data: { type: 'school_classes', id: school_class.id, attributes: { name: '1C' } } }

      put school_class_path(school_class),
          params: put_school_class.to_json,
          headers: { 'Content-Type': 'application/vnd.api+json' }

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq '1C'
    end
  end

  # destroy
  describe 'DELETE /school_class/:id' do
    it 'deletes the specified school_class' do
      school_class = FactoryGirl.create :school_class

      expect do
        delete school_class_path(school_class)

        expect(response).to have_http_status(:no_content)
      end.to change(SchoolClass, :count).by(-1)
    end
  end
end
