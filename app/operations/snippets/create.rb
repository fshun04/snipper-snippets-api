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
      rescue StandardError => e
        code = 400
        detail = e.message

        fail!([errors_with_code(code, detail)], interrupt: true)
      end
    end


    # def create_snippet!
    #   pp "BEGIN create_snippet!"

    #   ActiveRecord::Base.transaction do
    #     pp "BEGIN transaction"

    #     @snippet = current_user.snippets.new(snippet_creation_attributes)

    #     if @snippet.save
    #       pp "Snippet saved successfully: #{@snippet.inspect}"
    #     else
    #       pp "Error during snippet saving: #{@snippet.errors}"
    #       code = 400
    #       detail = "Validation error"
    #       fail!([errors_with_code(code, detail)], interrupt: true)
    #     end
    #   end

    #   pp "END create_snippet!"
    # rescue => e
    #   pp "Error outside transaction: #{e.inspect}"
    #   code = 400
    #   detail = e.message
    #   fail!([errors_with_code(code, detail)], interrupt: true)
    # end

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