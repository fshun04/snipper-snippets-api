module Snippets
  class Index
    prepend BaseOperation

    param :params
    param :current_user, default: -> { nil }

    attr_reader :result

    def call
      validate_params
      set_init_results
    end

    private

    def set_init_results
      @result = MakeResultIndex.new.make_index(::Indexes::Snippet, current_user.snippets, params)
    end

    def validate_params
      validation = ::Snippets::Index::ValidateParams.new.call(params)
      return if validation.success?

      code = 400
      detail = validation.errors.to_h
      interrupt_with_errors!([errors_with_code(code, detail)])
    end
  end
end