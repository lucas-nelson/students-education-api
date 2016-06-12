require 'rails_helper'

RSpec.describe Students::StudentsCompletionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/students/1/completions').to route_to('students/students_completions#create', student_id: '1')
    end

    it 'routes to #index' do
      expect(get: '/students/1/completions').to route_to('students/students_completions#index', student_id: '1')
    end
  end
end
