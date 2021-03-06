class InvitationCreatedMessageJob < Struct.new(:invitation_id)
  PRIORITY = 1

  def self.enqueue(invitation)
    Delayed::Job.enqueue(new(invitation.id), priority: PRIORITY)
  end

  def perform
    invitee.invite(invitation)
  end

  def error(job, exception)
    Airbrake.notify(exception)
  end

  private

  def invitation
    @invitation ||= Invitation.find(invitation_id)
  end

  def invitee
    @invitee ||= invitation.invitee
  end

  def sender
    @sender ||= invitation.sender
  end
end
