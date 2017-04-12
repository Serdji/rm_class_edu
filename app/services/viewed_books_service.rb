class ViewedBooksService < ViewedService
  LIMIT = 12
  KEY = 'viewed_books'.freeze

  def collections
    ids = collection_ids
    return [] unless ids.any?

    collections = Textbook.publicable
                          .includes(:cover, subject: [:color, :icon])
                          .where(id: ids).limit(limit)

    collections.sort_by { |x| ids.index(x.id) }
  end
  alias books collections
  alias book_ids collection_ids

  def key
    KEY
  end

  def limit
    LIMIT
  end
end
