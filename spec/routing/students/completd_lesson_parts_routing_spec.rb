require 'rails_helper'

RSpec.describe Students::CompletedLessonPartsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/students/1/completed_lesson_parts').to(
        route_to('students/completed_lesson_parts#create', student_id: '1')
      )
    end

    it 'routes to #destroy' do
      expect(delete: '/students/1/completed_lesson_parts/1').to(
        route_to('students/completed_lesson_parts#destroy', id: '1', student_id: '1')
      )
    end

    it 'routes to #index' do
      expect(get: '/students/1/completed_lesson_parts').to(
        route_to('students/completed_lesson_parts#index', student_id: '1')
      )
    end

    it 'routes to #show' do
      expect(get: '/students/1/completed_lesson_parts/1').to(
        route_to('students/completed_lesson_parts#show', id: '1', student_id: '1')
      )
    end
  end
end
