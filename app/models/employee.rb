class Employee < ApplicationRecord
  has_secure_password
  has_many :subordinates, class_name: "Employee",
  foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee", optional: true
  belongs_to :organization, optional: true
  has_many :reviews
  has_many :given_reviews, class_name: "Review", foreign_key: "reviewer_id"
  has_many :received_reviews, class_name: "Review", foreign_key: "reviewed_id"
  has_and_belongs_to_many :skills
  has_one :slack_team, through: :organization
  belongs_to :channel
  has_many :messages
  
  accepts_nested_attributes_for :skills
  # accepts_nested_attributes_for :given_reviews
  # accepts_nested_attributes_for :received_reviews
  validates :email, uniqueness: true, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def fetch_messages
    if self.slack_id
      channel_ids = self.channels
      # Channel.find_by(slack_id: channel_ids[1]).fetch_messages
      all_messages = channel_ids.map{|c| Channel.find_by(slack_id: c).fetch_messages}
      cleaned = messages.flatten.select{|m| !m['error']}
      user_messages = cleaned.flatten.select{|m| !m['error']}.select{|m| m.slack_user_id == self.slack_id}
    else 
      return {errors: "User is not on slack"}
    end

  end

  def channels
    slack_channels = []
    response = self.request_channels
    slack_channels << response['channels']
    
    while !response['response_metadata']['next_cursor'].empty?
      response = self.request_channels(response['response_metadata']['next_cursor'] )
      slack_channels << response['channels']
    end  
    channels_ids = slack_channels.flatten.map{|c| c['id']}
  end
  

  def request_channels(cursor = nil)
    resp = Faraday.get("https://slack.com/api/users.conversations") do |req| 
      if cursor
        req.params['cursor'] = cursor
      end
      req.params['user'] = self.slack_id
      req.headers['Authorization'] = "Bearer #{self.slack_team.bot_token}" 
    end
    response = JSON.parse(resp.body)
  end
  
  
end
