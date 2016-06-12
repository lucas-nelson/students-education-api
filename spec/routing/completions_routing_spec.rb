require 'rails_helper'

RSpec.describe CompletionsController, type: :routing do
  describe 'routing' do
    it 'routes to #destroy' do
      expect(delete: '/completions/1').to route_to('completions#destroy', id: '1')
    end

    it 'routes to #show' do
      expect(get: '/completions/1').to route_to('completions#show', id: '1')
    end
  end
end
