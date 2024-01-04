module Sortable
  extend ActiveSupport::Concern

  included do
    column_names.each do |c|
      scope "ordered_by_#{c}".to_sym, ->(direction = :asc) { order(c => direction) }
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