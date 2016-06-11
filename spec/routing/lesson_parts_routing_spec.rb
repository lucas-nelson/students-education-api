require 'rails_helper'

RSpec.describe LessonPartsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/lesson_parts').to route_to('lesson_parts#index')
    end

    it 'routes to #show' do
      expect(get: '/lesson_parts/1').to route_to('lesson_parts#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/lesson_parts').to route_to('lesson_parts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/lesson_parts/1').to route_to('lesson_parts#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/lesson_parts/1').to route_to('lesson_parts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/lesson_parts/1').to route_to('lesson_parts#destroy', id: '1')
    end
  end
end
