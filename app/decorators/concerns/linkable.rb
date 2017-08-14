module Linkable
  extend ActiveSupport::Concern

  def link_highlight(text)
    pattern = %r{(?<!=["\'])(http[s]?://([^\.]+\.)?rambler.ru/?[^\s\<\>]*)(\s|\z|\<|\>)}
    replacement = '<a href="\\1">\\1</a>\\3'
    text.gsub(pattern, replacement)
  end
end
