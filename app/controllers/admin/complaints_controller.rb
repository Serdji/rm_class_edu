class Admin::ComplaintsController < Admin::ApplicationController
  decorates_assigned :complaints, :complaint, with: Admin::ComplaintDecorator
  before_action :find_object, only: [:update, :edit]

  add_breadcrumb :complaints, path: proc { admin_complaints_path }

  def index
    @search = ComplaintFilter.new(params[:complaint_filter])
    # TODO: Fix N + 1
    @complaints = @search.apply(Qa::Complaint.order('complaints.created_at' => :desc)
                               .where(page_size_params.to_h)
                               .where(include: 'user'))
  end

  def edit
    add_breadcrumb(complaint.title(false))
  end

  def update
    add_breadcrumb(complaint.title(false))
    save
  end

  private

  def find_object
    @complaint ||= Qa::Complaint.find(params[:id], include: 'user,complainable')
    raise Admin::NotFoundError unless @complaint
    @complaint
  end

  def complaint_params
    params.require(:complaint).permit(:id, :comment)
  end

  def save
    @complaint.assign_attributes(complaint_params.to_h)

    respond_to do |format|
      if @complaint.valid?(:admin) && @complaint.save
        back_link = edit_admin_complaint_path(@complaint)
        success_save format, back_link, human_notice('success')
      else
        fail_save format, @complaint, human_notice('danger')
      end
    end
  end

  def success_save(format, link, message)
    format.html { redirect_to link, success: message }
    format.json { render json: { success: message } }
  end

  def fail_save(format, object, message)
    format.html do
      flash.now['danger'] = message
      render object.persisted? ? :edit : :new
    end
    format.json do
      render json: { error: object.errors.full_messages.join("\n") },
             status: :unprocessable_entity
    end
  end

  def human_notice(type)
    t("flashes.#{action_name}.#{type}")
  end
end
