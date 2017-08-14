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

  def most_discussing_questions_key
    key = [:most_discussing_questions]

    if controller_name == 'tags' && action_name == 'show'
      key << 'tags'
      key << params[:slug]
    end

    key
  end

  def most_discussing_questions
    if controller_name == 'tags' && action_name == 'show'
      tags_facade.discussing_questions
    else
      application_facade.most_discussing_questions
    end
  end
end
