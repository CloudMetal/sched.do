class ActivityCreator
  def initialize(user, action, event)
    @action = action
    @user = user
    @event = event
  end

  def create
    response = RestClient.post rest_client_url(@user.access_token),
    generate_json,
    :content_type => :json,
    :accept => :json

  rescue Exception => e
    Rails.logger.debug(e.response.inspect)
    Rails.logger.debug(generate_json.inspect)
    raise
  end

  private

  def generate_json
    {
      activity: {
        actor: { name: @user.name, email: @user.email },
        action: @action,
        object: {
          url: "https://sched.do/events/#{@event.id}",
          type: 'file',
          title: @event.name,
          image: 'http://sched.do/logo.gif'
        }
      },
      message: 'Fake message for testing purposes',
      users: @event.invitees_for_json
    }.to_json
  end

  def rest_client_url(access_token)
    "https://www.yammer.com/api/v1/activity.json?access_token=#{access_token}"
  end
end