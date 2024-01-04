# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      components: {
        securitySchemes: {
          bearerAuth: {
            type: 'http',
            scheme: 'bearer',
          }
        }
      },
      paths: {
        "/signup": {
          post: {
            summary: 'registers a new user',
            tags: ['Users'],
            parameters: [],
            responses: {
              '201': {
                description: 'user registered'
              },
              '422': {
                description: 'invalid request'
              }
            },
            requestBody: {
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      user: {
                        type: 'object',
                        properties: {
                          email: { type: 'string', format: 'email' },
                          password: { type: 'string', minLength: 6 },
                          name: { type: 'string' }
                        },
                        required: [:email, :password, :name]
                      }
                    }
                  }
                }
              },
              required: true
            }
          }
        },
        "/login": {
          post: {
            summary: 'logs a user in',
            tags: ['Users'],
            parameters: [],
            responses: {
              '201': {
                description: 'user logged in'
              },
              '422': {
                description: 'invalid request'
              }
            },
            requestBody: {
              content: {
                'application/json': {
                  schema: {
                    type: 'object',
                    properties: {
                      user: {
                        type: 'object',
                        properties: {
                          email: { type: 'string', format: 'email' },
                          password: { type: 'string', minLength: 6 }
                        },
                        required: [:email, :password]
                      }
                    }
                  }
                }
              },
              required: true
            }
          }
        },
        "/logout": {
          delete: {
            summary: 'logs a user out',
            tags: ['Users'],
            parameters: [
              {
                name: 'Authorization',
                in: 'header',
                description: 'Bearer <your_token>',
                required: true,
                schema: {
                  type: 'string'
                }
              }
            ],
            responses: {
              '200': {
                description: 'user logged out'
              },
              '401': {
                description: 'active session not found'
              }
            },
            security: [
              bearerAuth: []
            ]
          }
        }
      },
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ]
    }
  }


  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json

  module Rswag
    module Specs
      module ExampleGroupHelpers
        FILTER_OP_DESCRIPTIONS = {
          contains: 'contains the given value as a substring (case-insensitive)',
          lt: 'is strictly less than the given value',
          lte: 'is less than or equal to the given value',
          gt: 'is strictly greater than the given value',
          gte: 'is greater than or equal to the given value',
          ne: 'is not equal to the given value',
          nil => 'is equal to the given value'
        }.freeze

        def extra_opts(key)
          { }
        end

        def document_filter_parameter(key, opts)
          if opts == { in: [] }
            parameter name: "filter[#{key}][in][]",
                      in: :query,
                      type: :array,
                      items: { type: :string, **extra_opts(key) },
                      collectionFormat: :multi,
                      required: false,
                      description: "Causes the response to include only records whose `#{key}` attribute is equal to one of the given values."
          elsif opts.nil? || opts.is_a?(Symbol)
            desc = FILTER_OP_DESCRIPTIONS.fetch(opts)
            raise "missing doc for filter operator: #{opts}" unless desc

            parameter name: "filter[#{key}]" + (opts.nil? ? '' : "[#{opts}]"),
                      in: :query,
                      type: :string,
                      required: false,
                      description: "Causes the response to include only records whose `#{key}` attribute #{desc}.",
                      **extra_opts(key)
          else
            raise "don't know how to document key=#{key} opts=#{opts.inspect}"
          end
        end

        def document_index_parameters(index_class)
          sortable_fields = index_class::SORTABLE_FIELDS.map { |f| "`#{f}`" }.join(', ')
          parameter name: :sort, in: :query, type: :string, required: false, description: "Comma-separated list of fields to sort by. Available fields: #{sortable_fields}. Prefix a field by `-` to reverse the sort order. For example `foo,-bar` sorts by `foo` in ascending order then by `bar` in descending order."
          index_class::FILTERABLE_FIELDS.each do |filter|
            if filter.is_a?(Hash)
              filter.each do |key, ops|
                ops.each do |op|
                  document_filter_parameter(key, op)
                end
              end
            else
              document_filter_parameter(filter, nil)
            end
          end
        end
      end
    end
  end
end