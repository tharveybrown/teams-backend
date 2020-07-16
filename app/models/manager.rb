class Manager::SlackApiClient
  attr_reader :client, :slack_user

  def initialize(slack_user)
    @slack_user = slack_user
    @client = Slack::Web::Client.new(token: slack_user.token)
    @client.auth_test
  rescue => e
    Rails.logger.warn(<<~LOG)
      Error @Manager::SlackApiClient#initialize
      Msg: #{e.class} #{e.message}
    LOG

    @client = nil
  end

  def valid?
    client
  end
end
end