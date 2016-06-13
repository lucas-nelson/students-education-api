require 'rails_helper'

RSpec.describe 'LessonPartParts', type: :request do
  # index
  describe 'GET /lesson_parts' do
    it 'lists all the lesson_parts' do
      FactoryGirl.create :lesson_part
      FactoryGirl.create :lesson_part, name: "don't upset the queen!", ordinal: 2

      get lesson_parts_path

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)
      names = body.fetch('data').map { |lesson_part| lesson_part.fetch('attributes').fetch('name') }

      expect(names).to match_array(["don't upset the king", "don't upset the queen!"])
    end
  end

  # show
  describe 'GET /lesson_parts/:1' do
    let(:lesson_part) { FactoryGirl.create :lesson_part }

    it 'returns the specified lesson_part' do
      get lesson_part_path(lesson_part)

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq "don't upset the king"
    end
  end

  # create
  describe 'POST /lesson_parts' do
    it 'creates the specified lesson_part' do
      lesson = FactoryGirl.create :lesson
      lesson_part = { data: { type: 'lesson_parts', attributes: { lesson_id: lesson.id,
                                                                  name: "don't upset the queen!",
                                                                  ordinal: 2 } } }

      expect do
        post lesson_parts_path, params: lesson_part.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        expect(response).to have_http_status(:created)
        expect(response.headers['Location']).to eq lesson_part_url(LessonPart.last)

        body = JSON.parse(response.body)
        attributes = body.fetch('data').fetch('attributes')

        expect(attributes.fetch('name')).to eq "don't upset the queen!"
        expect(attributes.fetch('ordinal')).to eq 2
      end.to change(LessonPart, :count).by 1
    end

    it 'fails to create the specific lesson_part with missing data' do
      lesson_part = { data: { type: 'lesson_parts', attributes: { foo: 'bar' } } }

      expect do
        post lesson_parts_path, params: lesson_part.to_json, headers: { 'Content-Type': 'application/vnd.api+json' }

        body = JSON.parse(response.body)
        errors = body.fetch('errors')
        errors = errors.sort_by { |error| [error.dig('source', 'pointer'), error['detail']] }

        expected = [
          { 'source' => { 'pointer' => '/data/attributes/lesson' },  'detail' => 'must exist' },
          { 'source' => { 'pointer' => '/data/attributes/name' },    'detail' => "can't be blank" },
          { 'source' => { 'pointer' => '/data/attributes/ordinal' }, 'detail' => "can't be blank" },
          { 'source' => { 'pointer' => '/data/attributes/ordinal' }, 'detail' => 'is not a number' }
        ]

        expect(errors).to eql(expected)
      end.not_to change(LessonPart, :count)
    end
  end

  # update
  describe 'PUT /lesson_part/:id' do
    it 'updates the specified lesson_part' do
      lesson_part = FactoryGirl.create :lesson_part

      put_lesson_part = { data: { type: 'lesson_parts',
                                  id: lesson_part.id,
                                  attributes: { name: "don't upset the queen!" } } }

      put lesson_part_path(lesson_part),
          params: put_lesson_part.to_json,
          headers: { 'Content-Type': 'application/vnd.api+json' }

      expect(response).to have_http_status(:success)

      body = JSON.parse(response.body)

      expect(body.fetch('data').fetch('attributes').fetch('name')).to eq "don't upset the queen!"
    end
  end

  # destroy
  describe 'DELETE /lesson_part/:id' do
    it 'deletes the specified lesson_part' do
      lesson_part = FactoryGirl.create :lesson_part

      expect do
        delete lesson_part_path(lesson_part)

        expect(response).to have_http_status(:no_content)
      end.to change(LessonPart, :count).by(-1)
    end

    it 'deletes completed lesson parts too' do
      lesson_part = FactoryGirl.create :lesson_part, :with_students

      expect do
        delete lesson_part_path(lesson_part)

        expect(response).to have_http_status(:no_content)
      end.to change(Completion, :count).by(-1)
    end
  end
end
