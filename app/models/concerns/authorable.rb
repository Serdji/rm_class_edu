module Authorable
  extend ActiveSupport::Concern

  included do
    has_many :author_books, -> { order('author_books.placement_index') }, dependent: :destroy
    has_many :authors, through: :author_books

    before_save do
      if @authors_ordering
        authors_ordering = @authors_ordering.map(&:to_i).map.with_index(1).to_h
        author_books.each do |link|
          link.update_attribute(:placement_index, authors_ordering[link.author_id])
        end
      end
    end
  end

  def assign_attributes(params)
    @authors_ordering = params[:author_ids]
    super(params)
  end
end
