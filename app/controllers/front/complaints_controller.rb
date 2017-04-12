class Front::ComplaintsController < Front::ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    complaint = Qa::Complaint.create(complaint_params.to_h)

    if complaint.response_errors.any?
      render json: { errors: complaint.response_errors }, status: :unprocessable_entity
    else
      render json: { status: :ok }, status: :created
    end
  end

  private

  def complaint_params
    params.require(:complaint).permit(
      :complainable_id, :complainable_type,
      :body, :email, cause_ids: []
    ).merge(user_id: current_user.id)
  end
end
