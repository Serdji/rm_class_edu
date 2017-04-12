module Front::RelationLinksHelper
  def url_for_page(page)
    url_for(
      controller: controller_name, action: action_name,
      page: page, trailing_slash: true
    )
  end

  def rel_link(direction, page)
    content_tag(:link, nil, rel: direction, href: url_for_page(page))
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  def relation_links(collection)
    links = []

    collection = collection.object if collection.respond_to?(:object)

    current_page = collection.current_page
    total_pages = collection.total_pages

    return if total_pages == 1

    links << rel_link(:next, 2) if current_page == 1

    links << rel_link(:prev, total_pages - 1) if current_page == total_pages

    if current_page > 1 && current_page < total_pages
      links << rel_link(:prev, current_page - 1)
      links << rel_link(:next, current_page + 1)
    end

    safe_join(links)
  end
end
