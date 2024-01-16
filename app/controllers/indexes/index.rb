# frozen_string_literal: true

module Indexes
  class Index
    DEFAULT_SORTING = { created_at: :desc }.freeze
    MAX_PAGE_SIZE = 100
    INCLUDES = [].freeze
    SYNTHETIC_INCLUDES = [].freeze
    EXTRA_ACTIVE_RECORD_INCLUDES = [].freeze

    def initialize(url, params, collection)
      @url = url
      @params = params
      @collection = collection
    end

    def options
      {
        meta: meta,
        links: links
      }.tap do |h|
        h[:include] = self.class::INCLUDES.dup + self.class::SYNTHETIC_INCLUDES.dup
      end
    end

    def meta
      { total: filtered.total_count }
    end

    def filtered_unpaginated
      @filtered_unpaginated =
        @collection
          .apply_filters(filter_params)
          .order_by(sort_params)
    end

    def filtered
      @filtered =
        filtered_unpaginated
          .page(@params.dig(:page, :number))
          .per(page_size)
          .includes(self.class.transform_includes(self.class::INCLUDES))
          .includes(self.class::EXTRA_ACTIVE_RECORD_INCLUDES)
    end

    def self.transform_includes(includes)
      includes.each_with_object({}) do |name, hash|
        name.to_s.split('.').map(&:to_sym).inject(hash) do |child, name_part|
          child[name_part] ||= {}
        end
      end
    end

    private

    def filter_params
      @params.slice(:filter).permit(filter: self.class::FILTERABLE_FIELDS).fetch(:filter, {})
    end

    def sort_params
      SortParams.sorted_fields(
        @params[:sort],
        self.class::SORTABLE_FIELDS,
        self.class::DEFAULT_SORTING
      )
    end

    def page_size
      size = @params.dig(:page, :size)
      return nil unless size

      size.to_i > self.class::MAX_PAGE_SIZE ? self.class::MAX_PAGE_SIZE : size
    end

    def links
      PaginationLinks.new(
        filtered,
        @url,
        @params
      ).as_json
    end
  end
end