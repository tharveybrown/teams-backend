class SlackTeam < ApplicationRecord
  belongs_to :organization
  has_many :employees, through: :organization

  def fetch_channels(access_token)
    resp = Faraday.get("https://slack.com/api/conversations.list") do |req| 
      req.headers['Authorization'] = "Bearer #{access_token}" 
    end
    response = JSON.parse(resp.body)
    
  end

  def users(access_token)
    resp = Faraday.get("https://slack.com/api/users.list") do |req| 
      req.headers['Authorization'] = "Bearer #{access_token}" 
    end
    response = JSON.parse(resp.body)
    response['members']
  end

end
