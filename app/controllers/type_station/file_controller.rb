module TypeStation
  class FileController < TypeStation::ApplicationController

    def download
      redirect_to private_download_url
    end

    private

    def private_download_url
      Cloudinary::Utils.private_download_url([params[:identifier], params[:format]].join('.'), params[:format], resource_type: :raw, attachment: true, expires_at: 1.minute.from_now)
    end

  end
end
