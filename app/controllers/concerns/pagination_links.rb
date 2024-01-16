# frozen_string_literal: true

class PaginationLinks
  FIRST_PAGE = 1

  attr_reader :collection

  def initialize(collection, url, params)
    @collection = collection
    @url = url
    @params = params.slice(:filter, :sort).permit(:sort, filter: {}).to_unsafe_h
  end

  def as_json(_options = {})
    {
      self: location_url,
      first: first_page_url,
      prev: prev_page_url,
      next: next_page_url,
      last: last_page_url
    }
  end

  private

  def location_url
    url_for_page(collection.current_page)
  end

  def first_page_url
    url_for_page(1)
  end

  def last_page_url
    if collection.total_pages.zero?
      url_for_page(FIRST_PAGE)
    else
      url_for_page(collection.total_pages)
    end
  end

  def prev_page_url
    return nil if collection.current_page == FIRST_PAGE

    url_for_page(collection.current_page - FIRST_PAGE)
  end

  def next_page_url
    return nil if collection.total_pages.zero? || collection.current_page == collection.total_pages

    url_for_page(collection.next_page)
  end

  def url_for_page(number)
    params = @params.merge(page: { size: per_page, number: number })
    "#{@url}?#{params.to_query}"
  end

  def per_page
    @per_page ||= collection.try(:per_page) || collection.try(:limit_value) || collection.size
  end
end
