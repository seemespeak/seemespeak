require 'test_helper'

class AdminNotifierTest < ActionMailer::TestCase
  tests AdminNotifier
  test "send_entries_need_moderation_email" do
    # Send the email, then test that it got queued
    email = AdminNotifier.send_entries_need_moderation_email('test@example.com').deliver
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal ['notifier@seemmespeak.com'], email.from
    assert_equal ['test@example.com'], email.to
    assert_equal 'Some Videos on Seemmespeak need Moderation.', email.subject
  end

  test "entries_need_moderation" do
    # clear mail delivery queue
    ActionMailer::Base.deliveries = []
    Entry.delete_all

    Entry.new(:transcription => "test", :reviewed => true).index
    sleep 1

    # calling entries_need_moderation when there are no unmodereated entires, should not send out mail.
    AdminNotifier.entries_need_moderation
    assert ActionMailer::Base.deliveries.empty?

    # calling entries_need_moderation when there are unmodereated entires, should send out mail.
    Entry.new(:transcription => "test").index
    sleep 1
    AdminNotifier.entries_need_moderation
    assert !ActionMailer::Base.deliveries.empty?
  end
end
