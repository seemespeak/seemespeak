class AdminSettings < Settingslogic
  source "#{Rails.root}/config/admin_settings.yml"
  namespace Rails.env
end
