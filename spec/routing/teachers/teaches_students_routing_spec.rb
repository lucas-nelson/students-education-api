require 'rails_helper'

RSpec.describe Teachers::TeachesStudentsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/teachers/1/teaches_students').to(
        route_to('teachers/teaches_students#index', teacher_id: '1')
      )
    end
  end
end
