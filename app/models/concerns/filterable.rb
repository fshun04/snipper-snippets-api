# # frozen_string_literal: true

# module Filterable
#   extend ActiveSupport::Concern

#   included do
#     columns.each do |c|
#       case c.type
#       when :string
#         scope "filter_#{c.name}_contains", ->(val) { where "#{table_name}.#{c.name} LIKE ?", "%#{val}%" }
#       when :decimal, :datetime, :integer, :date
#         scope "filter_#{c.name}_gt", ->(val) { where "#{table_name}.#{c.name} > ?", val }
#         scope "filter_#{c.name}_lt", ->(val) { where "#{table_name}.#{c.name} < ?", val }
#         scope "filter_#{c.name}_gte", ->(val) { where "#{table_name}.#{c.name} >= ?", val }
#         scope "filter_#{c.name}_lte", ->(val) { where "#{table_name}.#{c.name} <= ?", val }
#       end
#       scope "filter_#{c.name}", ->(val) { where("#{table_name}.#{c.name} = ?", val) }
#       scope "filter_#{c.name}_ne", ->(val) { where("#{table_name}.#{c.name} <> ?", val) }
#       scope "filter_#{c.name}_in", ->(val) { where("#{table_name}.#{c.name} in (?)", val) }
#     end
#   end

#   module ClassMethods
#     def apply_filters(filtering_params)
#       results = where(nil) # create an anonymous scope
#       filtering_params.each do |key, filter|
#         if filter.is_a?(String)
#           results = results.public_send("filter_#{key}", filter) if filter.present?
#         else
#           filter.each do |type, value|
#             results = results.public_send("filter_#{key}_#{type}", value) if value.present?
#           end
#         end
#       end
#       results
#     end
#   end
# end

module Filterable
  extend ActiveSupport::Concern

  included do
    columns.each do |c|
      case c.type
      when :string
        if c.name == 'encrypted_content'
          scope "filter_content_contains", lambda { |val|
            where("#{table_name}.encrypted_content IS NOT NULL")
              .find_each(batch_size: 100)
              .select { |record| record.send(:decrypt_and_search, val) }
              .yield_self { |records| Snippet.where(id: records.map(&:id)) }
          }
        else
          scope "filter_#{c.name}_contains", ->(val) { where("#{table_name}.#{c.name} LIKE ?", "%#{val}%") }
        end
      when :decimal, :datetime, :integer, :date
        scope "filter_#{c.name}_gt", ->(val) { where("#{table_name}.#{c.name} > ?", val) }
        scope "filter_#{c.name}_lt", ->(val) { where("#{table_name}.#{c.name} < ?", val) }
        scope "filter_#{c.name}_gte", ->(val) { where("#{table_name}.#{c.name} >= ?", val) }
        scope "filter_#{c.name}_lte", ->(val) { where("#{table_name}.#{c.name} <= ?", val) }
      end

      scope "filter_#{c.name}", ->(val) { where("#{table_name}.#{c.name} = ?", val) }
      scope "filter_#{c.name}_ne", ->(val) { where("#{table_name}.#{c.name} <> ?", val) }
      scope "filter_#{c.name}_in", ->(val) { where("#{table_name}.#{c.name} IN (?)", val) }
    end
  end

  module ClassMethods
    def apply_filters(filtering_params)
      results = where(nil) # create an anonymous scope
      filtering_params.each do |key, filter|
        if filter.is_a?(String)
          results = results.public_send("filter_#{key}", filter) if filter.present?
        else
          filter.each do |type, value|
            if key == 'content' && type == 'contains'
              results = results.public_send("filter_#{key}_#{type}", value) if value.present?
            else
              results = results.public_send("filter_#{key}_#{type}", value) if value.present?
            end
          end
        end
      end
      pp "---RESULTS---"
      pp results
      pp results.class
      pp "---RESULTS---"
      results
    end
  end
end