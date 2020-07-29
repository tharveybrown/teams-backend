class SlackTeam < ApplicationRecord
  belongs_to :organization
  has_many :employees, through: :organization
  has_many :channels
  has_many :messages, through: :channels

  def fetch_channels(access_token)
      slack_channels = []
      response = self.request_channels
      slack_channels << response['channels']
      
      while !response['response_metadata']['next_cursor'].empty?
        response = self.request_channels(response['response_metadata']['next_cursor'] )
        slack_channels << response['channels']
      end  
    slack_channels.flatten.map{|channel| Channel.find_or_create_by(slack_id: channel['id']).update(slack_team: self, name: channel['name'], slack_id: channel['id'], topic: channel['topic']['value'], num_members: channel['num_members'])}
    self.channels
  end

 
  def users(access_token)
    resp = Faraday.get("https://slack.com/api/users.list") do |req| 
      req.headers['Authorization'] = "Bearer #{access_token}" 
    end
    response = JSON.parse(resp.body)
    response['members']
  end

  
  
  def request_channels(cursor = nil)
    resp = Faraday.get("https://slack.com/api/conversations.list") do |req| 
      if cursor
        req.params['cursor'] = cursor
      end
      req.params['exclude_archived'] = true
      req.params['types'] = 'public_channel'
      req.headers['Authorization'] = "Bearer #{self.bot_token}" 
    end
    response = JSON.parse(resp.body)
  end

  def find_by_email(email)
    resp = Faraday.get("https://slack.com/api/users.lookupByEmail?token=#{self.bot_token}&email=#{email}")
    response = JSON.parse(resp.body)
    if !!response['user']
      employee = Employee.find_by(email: response['user']['profile']['email'])
      employee.slack_id = response['user']['id']
      employee.save
    end
    response
  end


end
