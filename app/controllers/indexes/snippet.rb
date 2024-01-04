# frozen_string_literal: true

module Indexes
  class Snippet < Index
    SORTABLE_FIELDS = %i[content created_at updated_at].freeze
    FILTERABLE_FIELDS = [
      content: [:contains],
      created_at: %i[lt lte gt gte],
      updated_at: %i[lt lte gt gte]
    ].freeze
    INCLUDES = %i[user].freeze
  end
end
