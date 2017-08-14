class Builder::CSV::Tag
  def initialize(collection)
    @collection = collection
  end

  def generate_line(body, head = nil, options = { col_sep: ';' })
    lines = @collection.collect do |item|
      CSV.generate_line(encode(body.collect { |x| item.send(x) }), options)
    end
    lines.insert(0, CSV.generate_line(encode(head), options)) if head
    lines.join
  end

  private

  def encode(item, encoding = 'cp1251')
    if item.is_a? Array
      item.collect { |x| encode(x) }
    elsif item.respond_to? :encode
      item.encode(encoding)
    else
      item
    end
  end
end
