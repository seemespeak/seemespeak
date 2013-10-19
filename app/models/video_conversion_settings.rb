class VideoConversionSettings < Settingslogic
  source "#{Rails.root}/config/video_conversion.yml"
  namespace Rails.env
end
