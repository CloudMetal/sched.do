class Invitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :invitee, polymorphic: true
  belongs_to :sender, polymorphic: true
  belongs_to :vote

  accepts_nested_attributes_for :invitee

  validates :event_id, presence: true
  validates :invitee_type, presence: true
  validates :invitee_id, presence: { message: 'is invalid' }
  validates :invitee_id, uniqueness: {
    message: 'has already been invited',
    scope: [:invitee_type, :event_id]
  }

  def invite
    if save
      queue_created_jobs
    end
  end

  def invite_without_notification
    save
  end

  def deliver_reminder_from(reminder_sender)
    if not invitee.voted_for_event?(event)
      invitee.remind(self, reminder_sender)
      set_reminded_at
    end
  end

  def self.deliver_automatic_reminders
      due_for_reminder.each do |invitation|
        UserMailer.reminder(invitation, invitation.sender).deliver
        invitation.set_reminded_at
    end
  end

  def self.due_for_reminder
    where('sender_id IS NOT NULL').
      where("invitee_type <> 'Group'").
      where('created_at <= ?', 5.days.ago).
      where('vote_id IS NULL').
      where('reminded_at IS NULL')
  end

  def set_reminded_at
    self.update_attributes!(reminded_at: Time.now.utc)
  end

  private

  def queue_created_jobs
    send_invitation_created_message
    send_activity_message
  end

  def send_invitation_created_message
    InvitationCreatedMessageJob.enqueue(self)
  end

  def send_activity_message
    if sender.yammer_user?
      ActivityCreatorJob.enqueue(sender, 'share', event)
    end
  end
end
