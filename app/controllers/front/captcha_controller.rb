class Front::CaptchaController < Front::ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    captcha = RamblerID::Utility.get_captcha(type: params[:type])
    json = { id: captcha.id, image: captcha.image, length: captcha.length }

    render json: json
  end

  def check
    id, input, type = params.values_at(:id, :input, :type)
    result = RamblerID::Utility.captcha_valid?(id: id, input: input, type: type)

    render json: { result: result }
  end
end
