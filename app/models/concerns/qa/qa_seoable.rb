module Qa::QaSeoable
  extend ActiveSupport::Concern

  included do
    attr_writer :seo
  end

  def save
    result = super
    return result unless respond_to?(:seo_attributes)
    seo.assign_attributes(seo_attributes)
    @seo.save
    result
  end

  def seo(force_reload = false)
    if force_reload || @seo.nil?
      @seo ||= id.present? ? find_seo(id) : build_seo
    else
      @seo
    end
  end

  def build_seo(attributes = {})
    @seo = Seo.new(extend_attributes(attributes))
  end

  def create_seo(attributes = {})
    Seo.create(extend_attributes(attributes))
  end

  def create_seo!(attributes = {})
    Seo.create!(extend_attributes(attributes))
  end

  private

  def find_seo(id)
    seo = Seo.find_by(seoable_type: self.class, seoable_id: id)
    seo || build_seo
  end

  def extend_attributes(attributes)
    attributes.merge(seoable_type: self.class, seoable_id: id)
  end
end
