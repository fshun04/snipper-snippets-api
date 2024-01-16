# module Sortable
#   extend ActiveSupport::Concern

#   included do
#     column_names.each do |c|
#       scope "ordered_by_#{c}".to_sym, ->(direction = :asc) { order(c => direction) }
#     end
#   end

#   module ClassMethods
#     def order_by(sort_params)
#       sort_params.inject(where(nil)) do |coll, (k, dir)|
#         coll.send("ordered_by_#{k}", dir)
#       end
#     end
#   end
# end

module Sortable
  extend ActiveSupport::Concern

  included do
    column_names.each do |c|
      if c == "encrypted_content"
        scope "ordered_by_content".to_sym, ->(direction = :asc) {
          decrypted_snippets = all.map { |snippet| snippet.decrypt_and_downcase }
          sorted_snippets = decrypted_snippets.sort_by { |snippet| snippet[:content] }.tap { |sorted| sorted.reverse! if direction == :desc }
          id_order = sorted_snippets.map { |snippet| snippet[:id] }
          order(Arel.sql("FIELD(id, #{id_order.join(', ')})"))
        }
      else
        scope "ordered_by_#{c}".to_sym, ->(direction = :asc) { order(c => direction) }
      end
    end
  end

  module ClassMethods

    def order_by(sort_params)
      sort_params.inject(where(nil)) do |coll, (k, dir)|
        coll.send("ordered_by_#{k}", dir)
      end
    end
  end
end