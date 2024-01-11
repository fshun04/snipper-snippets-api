# frozen_string_literal: true

module ErrorsFormatting
  extend ActiveSupport::Concern
  included do
    def errors_with_code(code, detail)
      {
        code: code,
        detail: detail
      }
    end
  end
end