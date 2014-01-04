class AdminNotifier < ActionMailer::Base
  default from: "notifier@seemmespeak.com"

  def entries_need_moderation
  	unmoderated_entires = Entry.search(:reviewed => false).total
  	Rails.logger.debug "#{unmoderated_entires} unmoderated Entries found..."

  	if(unmoderated_entires > 0)
  	  admin_emails = AdminSettings[:admin_emails]
  	  admin_emails.each do |email|
  	    AdminNotifier.send_entries_need_moderation_email(email).deliver
  	  end
  	end
  end

  def send_entries_need_moderation_email(email)
    Rails.logger.debug "sending out emails to #{email}.."
  	@user_email = email
    mail(to: @user_email, subject: 'Some Videos on Seemmespeak need Moderation.')
  end 

end
