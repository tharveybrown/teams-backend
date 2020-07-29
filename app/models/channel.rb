class Channel < ApplicationRecord
  belongs_to :slack_team
  has_many :messages
  has_many :employees, through: :slack_team
  has_one :personality

  def fetch_messages
 
    messages = try_messages
    messages.flatten.map{|m| Message.find_or_create_by(ts: m['ts'], channel: self).update(text: m['text'])}
    self.messages

  end

  def fetch_latest_messages
 
    resp =Faraday.get("https://slack.com/api/conversations.history") do |req| 
      req.params['channel'] = self.slack_id
      req.headers['Authorization'] = "Bearer #{self.slack_team.bot_token}"
    end
    response = JSON.parse(resp.body)
    
    if response['messages']
      messages = response['messages']
      messages.map{|m| Message.find_or_create_by(ts: m['ts'], channel: self).update(text: m['text'])}
      self.messages
    else
      response
    end
  end

  def try_messages
    slack_messages = []
    response = self.request_messages
    if response['messages']
      slack_messages << response['messages']
    end

    while response['messages']
      if response['response_metadata']
        response = self.request_messages(response['response_metadata']['next_cursor'] )
        slack_messages << response['messages']
      else
        return slack_messages << response['messages']
      end
    end  
    # messages = slack_channels.flatten.map{|c| c['id']}
    slack_messages
  end
  

  def request_messages(cursor = nil)
    resp =Faraday.get("https://slack.com/api/conversations.history") do |req| 
      if cursor
        req.params['cursor'] = cursor
      end
      req.params['channel'] = self.slack_id
      req.headers['Authorization'] = "Bearer #{self.slack_team.bot_token}"
    end
    response = JSON.parse(resp.body)
  end
  
  
end