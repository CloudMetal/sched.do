class User < ActiveRecord::Base
  serialize :extra, JSON
  attr_accessible :access_token, :encrypted_access_token, :name
  attr_encrypted :access_token, key: ENV['ACCESS_TOKEN_ENCRYPTION_KEY']

  has_many :events
  has_many :user_votes
  has_many :votes, through: :user_votes
  has_many :invitations, as: :invitee

  validates :access_token, presence: true
  validates :encrypted_access_token, presence: true
  validates :name, presence: true
  validates :yammer_user_id, presence: true

  def self.create_from_params!(params)
    create!(
      {
        access_token: params[:info][:access_token],
        yammer_staging: params[:provider] == "yammer_staging",
        email: params[:info][:email],
        image: params[:info][:image],
        name: params[:info][:name],
        nickname: params[:info][:nickname],
        yammer_network_id: params[:info][:yammer_network_id],
        yammer_profile_url: params[:info][:yammer_profile_url],
        yammer_user_id: params[:uid],
        extra: params[:extra]
      },
      { without_protection: true }
    )
  end

  def self.find_and_update_from_yammer(params)
    user = User.find_by_access_token(params[:info][:access_token])

    if user
      user.update_yammer_info(params)
    end

    user
  end

  def able_to_edit?(event)
    event.user == self
  end

  def build_user_vote
    user_votes.new
  end

  def create_yammer_activity(action, event)
    ActivityCreator.new(self, action, event).create
  end

  def guest?
    false
  end

  def in_network?(test_user)
    yammer_network_id == test_user.yammer_network_id
  end

  def image
    self[:image] || 'http://' + ENV['HOSTNAME'] + '/assets/no_photo.png'
  end

  def notify(invitation)
    if invitation.sender.in_network?(invitation.invitee)
      PrivateMessager.new(invitation).deliver
    else
      UserMailer.delay.invitation(self, invitation.event)
    end
  end

  def update_yammer_info(params)
    self.update_attributes(
      {
        access_token: params[:info][:access_token],
        yammer_staging: params[:provider] == "yammer_staging",
        email: params[:info][:email],
        image: params[:info][:image],
        name: params[:info][:name],
        nickname: params[:info][:nickname],
        yammer_profile_url: params[:info][:yammer_profile_url],
        yammer_user_id: params[:uid],
        extra: params[:extra]
      },
      { without_protection: true }
    )
  end

  def vote_for_suggestion(suggestion)
    votes.find_by_suggestion_id(suggestion.id)
  end

  def voted_for?(suggestion)
    vote_for_suggestion(suggestion).present?
  end

  def yammer_user?
    true
  end

  def yammer_endpoint
    yammer_staging ? "https://www.staging.yammer.com/" : "https://www.yammer.com/"
  end

end
