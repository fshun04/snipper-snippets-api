# frozen_string_literal: true

module Snippets
  class Create
    prepend BaseOperation

    param :params
    param :current_user, default: -> { nil }

    attr_reader :result

    def call
      validate_params
      create_snippet!
      set_result
    end

    private

    def validate_params
      validation = ::Snippets::Create::ValidateParams.new.call(@params)
      return if validation.success?

      code = 400
      detail = validation.errors.to_h

      interrupt_with_errors!([errors_with_code(code, detail)])
    end

    def create_snippet!
      ActiveRecord::Base.transaction do
        @snippet = current_user.snippets.create!(snippet_creation_attributes)
      rescue StandardError
        code = 400
        detail = I18n.t('operations.validation.something_went_wrong')

        fail!([errors_with_code(code, detail)], interrupt: true)
      end
    end

    def snippet_creation_attributes
      {
        content: @params.dig(:snippet, :content)
      }
    end

    def set_result
      @result = @snippet
    end
  end
end