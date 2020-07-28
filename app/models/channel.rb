class Channel < ApplicationRecord
  belongs_to :slack_team
  has_many :messages
  has_many :employees, through: :slack_team
  has_one :personality

  def fetch_messages
    resp = Faraday.get("https://slack.com/api/conversations.history") do |req| 
      req.params['channel'] = self.slack_id
      req.headers['Authorization'] = "Bearer #{self.slack_team.bot_token}"
    end
    
    response = JSON.parse(resp.body)
    if response['error']
      return response 
    end
    messages = response['messages']
    messages.map{|message| Message.find_or_create_by(ts: message['ts'], channel: self).update( slack_id: message['client_msg_id'], text: message['text'], slack_user_id: message['user'], ts: message['ts'])}
    self.messages
  end
end