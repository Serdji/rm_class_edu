module Front::SvgHelper
  def svg(name:, klass:, prefix: true)
    use = tag(
      :use,
      'xmlns:xlink': 'http://www.w3.org/1999/xlink',
      'xlink:href': prefix ? "#icon-#{name}" : name
    )
    content_tag(:svg, use, class: klass)
  end

  # rubocop:disable Rails/OutputSafety
  def embedded_svg(app_name, _options = {})
    path = Rails.root.join('public/assets', app_name.to_s, 'sprite.svg')
    File.read(path).html_safe if File.exist?(path)
  end
end
