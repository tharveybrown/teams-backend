class SlackTeam < ApplicationRecord
  belongs_to :organization, optional: true

  def fetch_channels(access_token)
    resp = Faraday.get("https://slack.com/api/conversations.list") do |req| 
      req.headers['Authorization'] = "Bearer #{access_token}" 
    end
    response = JSON.parse(resp.body)
    # self.channels = JSON.parse(resp.body)
    self.save
  end

  

end
