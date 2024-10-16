require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.to_s + '/swagger'

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          ScrapeCarCreate: {
            type: :object,
            properties: {
              task_id: { type: :integer },
              url: { type: :string }
            },
            required: ['task_id', 'url']
          }
        }
      }
    }
  }
end
