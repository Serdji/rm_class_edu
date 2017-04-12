module FaviconHelper
  ICONS = [
    { 'apple-icon-57x57.png' => { rel: 'apple-touch-icon', sizes: '57x57' } },
    { 'apple-icon-60x60.png' => { rel: 'apple-touch-icon', sizes: '60x60' } },
    { 'apple-icon-72x72.png' => { rel: 'apple-touch-icon', sizes: '72x72' } },
    { 'apple-icon-76x76.png' => { rel: 'apple-touch-icon', sizes: '76x76' } },
    { 'apple-icon-114x114.png' => { rel: 'apple-touch-icon', sizes: '114x114' } },
    { 'apple-icon-120x120.png' => { rel: 'apple-touch-icon', sizes: '120x120' } },
    { 'apple-icon-144x144.png' => { rel: 'apple-touch-icon', sizes: '144x144' } },
    { 'apple-icon-152x152.png' => { rel: 'apple-touch-icon', sizes: '152x152' } },
    { 'apple-icon-180x180.png' => { rel: 'apple-touch-icon', sizes: '180x180' } },

    { 'android-icon-36x36.png' => { rel: 'icon', sizes: '36x36' } },
    { 'android-icon-48x48.png' => { rel: 'icon', sizes: '48x48' } },
    { 'android-icon-72x72.png' => { rel: 'icon', sizes: '72x72' } },
    { 'android-icon-96x96.png' => { rel: 'icon', sizes: '96x96' } },
    { 'android-icon-192x192.png' => { rel: 'icon', sizes: '192x192' } },

    { 'favicon-16x16.png' => { rel: 'icon', sizes: '16x16', type: 'image/png' } },
    { 'favicon-32x32.png' => { rel: 'icon', sizes: '32x32', type: 'image/png' } },
    { 'favicon-96x96.png' => { rel: 'icon', sizes: '96x96', type: 'image/png' } }
  ].freeze

  def include_favicons(prefix = nil)
    result = ICONS.map do |hash|
      key = ['icons', build_prefix(prefix), hash.keys.first].join('/')
      favicon_link_tag key, (hash.values.first || {})
    end

    safe_join(result)
  end

  def front_include_favicons(prefix = nil)
    result = ICONS.map do |hash|
      key = [Settings.favicon_hash, build_prefix(prefix), hash.keys.first].compact.join('/')
      favicon_link_tag key, (hash.values.first || {}).merge!(href: slash + key)
    end

    safe_join(result)
  end

  def slash
    Rails.env.development? ? '' : '/'
  end

  def front_default_opengraph(prefix = nil)
    DomainFactory.url +
      '/' +
      [Settings.favicon_hash, build_prefix(prefix), 'opengraph.png'].compact.join('/')
  end

  private

  def build_prefix(prefix)
    if Rails.env.start_with?('staging')
      Rails.env
    else
      prefix || 'front'
    end
  end
end
