# frozen_string_literal: true

module Snippets
  class Index
    class ValidateParams < Dry::Validation::Contract
      DATE_YYYY_MM_DD = 'yyyy-mm-dd'
      OPERATORS_LIST = %i[eq lte gte lt gt].freeze
      DATE_KIND_PARAMS = %i[
        created_at
        updated_at
      ].freeze

      schema do
        optional(:filter).hash do
          optional(:snippet).hash do
            optional(:content).filled(:string)
            optional(:user_id).filled(:string)
            optional(:created_at).hash do
              optional(:eq).filled(:string)
              optional(:gt).filled(:string)
              optional(:lt).filled(:string)
              optional(:gte).filled(:string)
              optional(:lte).filled(:string)
            end
            optional(:updated_at).hash do
              optional(:eq).filled(:string)
              optional(:gt).filled(:string)
              optional(:lt).filled(:string)
              optional(:gte).filled(:string)
              optional(:lte).filled(:string)
            end
          end
        end
      end

      rule(%i[filter snippet]) do # date-kind params validating
        value&.each do |date_param, hash|
          next if DATE_KIND_PARAMS.exclude?(date_param)

          message =
            if hash.empty?
              I18n.t('operations.validation.invalid_date_filter_empty')
            elsif hash.length > 1
              I18n.t('operations.validation.date_filter_should_have_one_op')
            else
              operator = hash.keys.first
              date = hash.values.first
              operator_error_message_if_applicable(operator)
              date_error_message_if_applicable(date)
            end

          key(key_name + [date_param]).failure(message) if message
        end
      end

      private

      def date_error_message_if_applicable(date)
        return unless date

        if date_format_invalid?(date)
          I18n.t('operations.validation.invalid_date.format', must_be: DATE_YYYY_MM_DD)
        elsif date_invalid?(date)
          I18n.t('operations.validation.invalid_date.content')
        end
      end

      def operator_error_message_if_applicable(operator)
        return if operator.blank?

        if OPERATORS_LIST.exclude?(operator)
          I18n.t('operations.validation.invalid_filter_operator',
                 operator: key, operator_list: OPERATORS_LIST)
        end
      end

      def date_format_invalid?(date)
        !RegExp::DATE_YYYY_MM_DD.match?(date)
      end

      def date_invalid?(date)
        !Date.valid_date?(*date.split('-').map(&:to_i))
      end
    end
  end
end