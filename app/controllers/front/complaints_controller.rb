class Front::ComplaintsController < Front::ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :create_user!, only: :create

  def create
    @complaint = Qa::Complaint.new(complaint_params.to_h)

    if @complaint.valid?(:front)
      check_captcha! if desktop_version?
      return if response_body.present?

      save
    else
      render_validation_errors @complaint.errors.messages
    end
  end

  private

  def save
    if @complaint.save
      activity_limiter.store if desktop_version?
      render json: { status: :ok }, status: :created
    else
      render_validation_errors complaint.response_errors
    end
  end

  def complaint_params
    params.require(:complaint).permit(
      :complainable_id, :complainable_type,
      :body, :email, cause_ids: []
    ).merge(user_id: current_user.id)
  end
end
