module Front::CacheHelper
  def mobile_collection_proc
    -> (object) { [:mobile, object] }
  end

  def desktop_collection_proc
    -> (object) { [:desktop, object] }
  end

  def cache_mobile(name = {}, options = {}, &block)
    name = Array(name)
    name.unshift :mobile

    cache(name, options, &block)
  end

  def cache_desktop(name = {}, options = {}, &block)
    name = Array(name)
    name.unshift :desktop

    cache(name, options, &block)
  end
end
