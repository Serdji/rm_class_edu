module Front::ApplicationHelper
  def canonical
    path = request.env['REQUEST_PATH']
    path = path.gsub(%r{\A/page-\d+/\z}, '/')
    path = path.gsub(%r{-page-\d+/\z}, '/')
    [Settings.host, path].join
  end

  def svg(name:, klass:, prefix: true)
    use = tag(
      :use,
      'xmlns:xlink': 'http://www.w3.org/1999/xlink',
      'xlink:href': prefix ? "#icon-#{name}" : name
    )
    content_tag(:svg, use, class: klass)
  end

  def embedded_svg(app_name, _options = {})
    path = Rails.root.join('public/assets', app_name.to_s, 'sprite.svg')
    raw(File.read(path)) if File.exist?(path)
  end

  def number_zero(i)
    (i.to_i + 1).to_s[1] == '0' ? '_number-left-zero' : ''
  end

  def number_one(i)
    (i.to_i + 1).to_s[1] == '1' ? '_number-left-one' : ''
  end

  def number_class(i)
    [number_zero(i), number_one(i)].join(' ')
  end

  def bold_chapter(str)
    chapter, name = str.split(':', 2)
    safe_join([content_tag('b', chapter), name], ':')
  end

  def nl2br(str)
    return unless str
    str.strip.gsub(/\n/, '<br />')
  end

  def a_logo(options = {})
    if controller_name == 'home' && action_name == 'index'
      { tag: 'div' }.merge options
    else
      { tag: 'a', href: root_path }.merge options
    end
  end

  def a_logo_header_front
    options = { class: 'menu__class', data: { cerber: { logo: 'logo_class' } } }
    a_logo(options)
  end

  def a_logo_header_mobile
    options = { class: 'heading__class', data: { cerber: { logo: 'logo_class' } } }
    a_logo(options)
  end

  def a_logo_footer_front
    a_logo(class: 'footer__class', data: { cerber: { logo: 'logo_footer_class' } })
  end

  def a_logo_footer_mobile
    a_logo(class: 'footer__class', data: { cerber: { logo: 'logo_footer_class' } })
  end

  def a_cover_link(is_link, options, &block)
    link = options[:href]
    params = options.reject { |key, _value| key == :href }
    if is_link
      link_to link, params, &block
    else
      content_tag :div, params, &block
    end
  end

  def sanitize(text, options = {})
    super(text, options).tr("\u{A0}", ' ').gsub(/\n/, '<br />')
  end

  def break_too_long_words(text, lenght = 35)
    text.to_str.gsub(/[-_0-9a-zа-яё?!\[\];,'"\.]{#{Regexp.quote(lenght.to_s)},}/i) do |match|
      match.scan(/.{1,#{Regexp.quote(lenght.to_s)}}/).join(' ')
    end
  end

  def qa_datetime_format(date)
    date_format = qa_date_format(date)
    date_format += date.strftime(', %H:%M') if date > Time.zone.yesterday - 0.seconds
    date_format
  end

  def qa_date_format(date)
    date_format = qa_today_format(date)
    date_format = "#{date_format} #{date.year}" if date.year != Time.zone.today.year
    date_format
  end

  def qa_today_format(date)
    if date.to_date == Time.zone.today
      'Сегодня'
    elsif date.to_date == Date.yesterday
      'Вчера'
    else
      "#{date.strftime('%-e')} #{t('date.month_names')[date.strftime('%-m').to_i]}"
    end
  end
end
