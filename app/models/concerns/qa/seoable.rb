module Qa::Seoable
  def seo
    return unless id
    @seo ||= Seo.find_by(seoable_attributes)
  end

  def build_seo(attributes = {})
    @seo = Seo.new(seoable_attributes(attributes))
  end

  def create_seo(attributes = {})
    @seo = Seo.create(seoable_attributes.merge(attributes))
  end

  private

  def seoable_attributes(attributes = {})
    attributes.merge(seoable_type: self.class.name, seoable_id: id)
  end
end
