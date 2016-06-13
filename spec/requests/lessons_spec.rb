require 'rails_helper'

RSpec.describe 'Lessons', type: :request do
  # index
  describe 'GET /lessons' do
    it 'lists all the lessons' do
      FactoryGirl.create :lesson, name: 'how not to lose your head', ordinal: 1
      FactoryGirl.create :lesson, name: 'what to pack when you travel to the wall', ordinal: 2

      get lessons_path

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      names = body.fetch('data').map { |lesson| lesson.fetch('attributes').fetch('name') }

      expect(names).to match_array(['how not to lose your head', 'what to pack when you travel to the wall'])
    end
  end

  # show
  describe 'GET /lessons/:1' do
    let(:lesson) { FactoryGirl.create :lesson, name: 'how not to lose your head' }

    it 'returns the specified lesson' do
      get lesson_path(lesson)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq 'how not to lose your head'
    end
  end

  # create
  describe 'POST /lessons' do
    it 'creates the specified lesson' do
      school_class = FactoryGirl.create :school_class

      lesson = { data: { type: 'lessons', attributes: { name: 'what to pack when you travel to the wall',
                                                        ordinal: 2,
                                                        school_class_id: school_class.id } } }

      expect do
        post lessons_path, params: lesson.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        expect(response).to have_http_status(:created)
        expect(response.headers['Location']).to eq lesson_url(Lesson.last)

        body = JSON.parse(response.body)
        attributes = body.fetch('data').fetch('attributes')

        expect(attributes.fetch('name')).to eq 'what to pack when you travel to the wall'
        expect(attributes.fetch('ordinal')).to eq 2
      end.to change(Lesson, :count).by 1
    end

    it 'fails to create the specific lesson with missing data' do
      lesson = { data: { type: 'lessons', attributes: { foo: 'bar' } } }

      expect do
        post lessons_path, params: lesson.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        body = JSON.parse(response.body)
        errors = body.fetch('errors')
        errors = errors.sort_by { |error| [error.dig('source', 'pointer'), error['detail']] }

        expected = [
          { 'source' => { 'pointer' => '/data/attributes/name' },    'detail' => "can't be blank" },
          { 'source' => { 'pointer' => '/data/attributes/ordinal' }, 'detail' => "can't be blank" },
          { 'source' => { 'pointer' => '/data/attributes/ordinal' }, 'detail' => 'is not a number' },
          { 'source' => { 'pointer' => '/data/attributes/school-class' }, 'detail' => 'must exist' }
        ]

        expect(errors).to eql(expected)
      end.not_to change(Lesson, :count)
    end
  end

  # update
  describe 'PUT /lesson/:id' do
    let(:lesson) { FactoryGirl.create :lesson }

    it 'updates the specified lesson' do
      put_lesson = { data: { type: 'lessons', id: lesson.id, attributes: { name: 'did I just lose my head' } } }

      put lesson_path(lesson), params: put_lesson.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq 'did I just lose my head'
    end
  end

  # destroy
  describe 'DELETE /lesson/:id' do
    it 'deletes the specified lesson' do
      lesson = FactoryGirl.create :lesson

      expect do
        delete lesson_path(lesson)

        expect(response).to have_http_status(:no_content)
      end.to change(Lesson, :count).by(-1)
    end

    it 'deletes lesson parts too' do
      lesson = FactoryGirl.create :lesson, :with_lesson_parts

      expect do
        delete lesson_path(lesson)

        expect(response).to have_http_status(:no_content)
      end.to change(LessonPart, :count).by(-3)
    end
  end
end
