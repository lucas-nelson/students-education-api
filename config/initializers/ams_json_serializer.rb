ActiveModel::Serializer.config.adapter = :json_api

Mime::Type.register 'application/json', :json, %w(application/json, application/vnd.api+json text/x-json)
