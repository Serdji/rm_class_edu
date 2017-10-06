module Concerns::Captcha
  # rubocop:disable Metrics/AbcSize
  def check_captcha!
    if activity_limiter.exceeded? && !activity_limiter.user_blocked?
      activity_limiter.block_user
      render json: { error: 'Create limit' }, status: 429
      return
    end

    if activity_limiter.user_blocked?
      if params[:captcha].present? && captcha_valid?
        activity_limiter.unblock_user
      else
        render(json: { error: 'Create limit' }, status: 429)
      end
    end
  end

  private

  def captcha_valid?
    @captcha_valid ||= begin
      captcha_params = params.require(:captcha).permit(:id, :input, :type).to_h
      captcha_params = captcha_params.to_h.symbolize_keys!
      RamblerID::Utility.captcha_valid?(**captcha_params)
    end
  end
end
