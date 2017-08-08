module TypeStation
  class FileController < TypeStation::ApplicationController

    IMAGE_FORMATS = ['jpg', 'jpe', 'jpeg', 'jpc', 'jp2', 'j2k', 'wdp', 'jxr', 'hdp', 'png', 'gif', 'gif', 'webp', 'webp', 'bmp', 'tif', 'tiff', 'ico', 'pdf', 'ps', 'ept', 'eps', 'eps3', 'psd', 'svg', 'ai', 'djvu', 'flif', 'tga']

    def download
      redirect_to private_download_url
    end

    private

    def private_download_url
      if IMAGE_FORMATS.include?(params[:format].downcase)
        Cloudinary::Utils.private_download_url(params[:identifier], params[:format], resource_type: :image, attachment: true, expires_at: 1.minute.from_now)
      else
        Cloudinary::Utils.private_download_url([params[:identifier], params[:format]].join('.'), params[:format], resource_type: :raw, attachment: true, expires_at: 1.minute.from_now)
      end
    end

  end
end
