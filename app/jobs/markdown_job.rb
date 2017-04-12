class MarkdownJob < ActiveJob::Base
  queue_as :markdown

  ALT_PATTERN = /\[(.*)\]/
  URL_PATTERN = %r{(http[s]?:\/\/.+)}
  ID_PATTERN = /(?:{:\s*((?:[\w-]+=[\w'"]+\s*)+)})?/

  IMAGE_PATTERN = /!#{ALT_PATTERN}\(#{URL_PATTERN}\)#{ID_PATTERN}/

  KRAMDOWN_OPTIONS = {
    auto_ids: false, math_engine: 'mathjaxnode', math_engine_opts: { format: 'svg' }
  }.freeze

  attr_reader :class_name, :object, :id

  def perform(class_name, id)
    @id = id
    @class_name = class_name

    @object = klass.find_by(id: id)
    @object ? fill : clear
  end

  private

  def fill
    object.with_lock do
      Rails.cache.data.pipelined do
        process.each { |field, html| Rails.cache.write(object.cachable_cache_key(field), html) }
      end
    end
  end

  def process
    markdown_fields.map do |field|
      content = object.send(field)

      if content
        replace_content(field, object)
        html = Kramdown::Document.new(content, KRAMDOWN_OPTIONS).to_html
      end

      [field, html]
    end
  end

  def replace_content(field, object)
    content = object.send(field)

    content.gsub!(IMAGE_PATTERN) do |match|
      alt = Regexp.last_match(1)
      tmp_url = Regexp.last_match(2)
      attrs = Regexp.last_match(3)

      data_id = attrs.split(/\s+/).find { |attr| attr.starts_with?(':data-id') }
      id = data_id[/\d+/] if data_id

      id.to_i.zero? ? create_image(match, alt, tmp_url) : match
    end

    object.update_column(field, content)
  end

  def create_image(match, alt, tmp_url)
    image = object.images.create(alt_text: alt, remote_image_url: tmp_url)
    match.sub!(':data-id="0"', ":data-id=\"#{image.id}\"")
    match.sub!(tmp_url, image.image_url)
  end

  def clear
    Rails.cache.data.pipelined do
      markdown_fields.each do |field|
        Rails.cache.delete(klass.cache_key(id, field))
      end
    end
  end

  def klass
    @klass ||= class_name.constantize
  end

  def markdown_fields
    klass.const_get(:MARKDOWN_FIELDS)
  end
end
