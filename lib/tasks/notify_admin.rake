namespace :notify_admin do

  desc "Notifies Admins about unmoderated Videos"
  task moderate_entries: :environment do
    AdminNotifier.entries_need_moderation
  end

end
