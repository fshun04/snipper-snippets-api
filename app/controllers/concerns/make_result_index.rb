# frozen_string_literal: true
class MakeResultIndex
  def make_index(cls, collection, query_params)
    cls.new '/snippets', ActionController::Parameters.new(query_params), collection
  end
end