module Users
  class Create
    prepend BaseOperation

    param :params

    attr_reader :result

    def call
      validate_params
      create_user!
      set_result
    end

    private

    def validate_params
      validation = ::Users::Create::ValidateParams.new.call(@params)
      return if validation.success?

      code = 400
      detail = validation.errors.to_h

      interrupt_with_errors!([errors_with_code(code, detail)])
    end

    def create_user!
      ActiveRecord::Base.transaction do
        @user = User.create!(user_creation_attributes)
      rescue StandardError => e
        code = 400
        # detail = I18n.t('operations.validation.something_went_wrong')
        detail = e.message

        fail!([errors_with_code(code, detail)], interrupt: true)
      end
    end

    def user_creation_attributes
      {
        email: @params.dig(:user, :email),
        password: @params.dig(:user, :password),
        name: @params.dig(:user, :name),
      }
    end

    def set_result
      @result = @user
    end
  end
end