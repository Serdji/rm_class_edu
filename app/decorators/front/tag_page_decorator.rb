class Front::TagPageDecorator < Draper::Decorator
  attr_accessor :seo

  include HumanDates
  delegate_all

  delegate :image_wide_stripe_url,
           :image_short_stripe_url,
           :image_thumb_with_shadow_url,
           :image_url,
           :slug,
           :name,
           :human_questions_counter,
           :human_answers_counter,
           to: :tagable

  delegate :title,
           :keywords,
           :description,
           to: :seo, prefix: true, allow_nil: true

  def tagable
    @tagable ||= if multi_tag?
                   Front::MultiTagDecorator.decorate(object.tagable)
                 else
                   Front::TagDecorator.decorate(object.tagable)
                 end
  end

  def seo
    @seo ||= tagable.seo
  end
end
