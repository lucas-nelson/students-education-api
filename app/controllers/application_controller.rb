# The base class for all out controllers
class ApplicationController < ActionController::API
  # https://github.com/rails-api/active_model_serializers/blob/master/docs/jsonapi/errors.md
  def render_jsonapi_errors(model)
    render json: model,
           status: :unprocessable_entity,
           adapter: :json_api,
           serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
