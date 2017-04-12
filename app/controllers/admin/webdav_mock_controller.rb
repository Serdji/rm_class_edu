class Admin::WebdavMockController < Admin::ApplicationController
  before_action :authenticate_employee!, except: [:create]

  def create
    file = params[:file]
    return unless file

    dest = Rails.root.join('public/tmp')
    FileUtils.mkdir_p(dest)

    filename = file.original_filename
    FileUtils.cp file.path, [dest, filename].join('/')

    render plain: [host, 'tmp', filename].join('/')
  end

  private

  def host
    [request.protocol, request.host_with_port].join('')
  end
end
