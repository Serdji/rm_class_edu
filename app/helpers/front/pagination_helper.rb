class FakeLinkRenderer < WillPaginate::ActionView::LinkRenderer
  def previous_or_next_page(page, text, classname)
    if page
      attributes = {
        path: url(page),
        class: classname,
        rel: rel_value(page)
      }

      @template.fake_link(text, attributes)
    else
      super
    end
  end
end

class MobileLinkRenderer < FakeLinkRenderer
  def left_gap
    link(gap_text, page, class: 'gap') if page > 0
  end

  def right_gap
    page = (1..4).cover?(current_page) ? 7 : (current_page + 3)
    link(gap_text, page, class: 'gap') if page <= total_pages
  end

  private

  def page
    if ((total_pages - 3)..total_pages).cover?(current_page)
      total_pages - 6
    else
      current_page - 3
    end
  end
end

module Front::PaginationHelper
  DEFAULT_OPTIONS = {
    inner_window: 1, outer_window: 0,
    renderer: FakeLinkRenderer
  }.freeze

  def pagination(collection, options = {})
    check_page_for(collection)

    options = DEFAULT_OPTIONS.merge(options)

    if options.delete(:mobile)
      options[:class] = 'pagination-mobile'
      options[:renderer] = MobileLinkRenderer
    end

    current = collection.current_page
    total = collection.total_pages

    for_first = (1..3).cover?(current)
    for_last = ((total - 2)..total).cover?(current)

    options[:inner_window] = 2 if for_first || for_last

    will_paginate(collection, options)
  end

  def check_page_for(collection)
    return if collection.total_pages.zero?

    if collection.current_page > collection.total_pages
      raise ActionController::RoutingError, 'Page out of scope'
    end
  end
end
