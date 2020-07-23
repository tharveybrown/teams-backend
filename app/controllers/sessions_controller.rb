require 'net/http'
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :create]

  def create
    temp_code = request.query_parameters[:code]
    uri = URI('https://slack.com/api/oauth.v2.access')
    origin = request.headers['origin']
    params = { :client_id => ENV['SLACK_CLIENT_ID'], :client_secret => ENV['SLACK_CLIENT_SECRET'], code: temp_code, redirect_uri: "#{origin}/dashboard" }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    # @employee = Employee.find_or_create_by(full_name: auth_hash.info.name, member_id: auth_hash.info.user_id)
    response = JSON.parse(res.body)
    bot_access_token = response['access_token']
    access_token = response['authed_user']['access_token']
    con = Faraday.new
    resp = con.post do |req| 
      req.url "https://slack.com/api/chat.postMessage" 
      req.headers['Authorization'] = "Bearer #{bot_access_token}" 
      req.body = '{ "channel": "CT8DCFL02", "text": "hiii" }' 
    end
    byebug
    @employee = Employee.find(session_user[:id])
    @employee.access_token = access_token
    @employee.save
    slack_team = SlackTeam.find_or_create_by(slack_id: response['team']['id'], name: response['team']['name'], organization_id: session_user.organization.id)
    channels = slack_team.fetch_channels(access_token)['channels'].map{|channel| {name: channel['name'], id: channel['id'], is_private: channel['is_private']}}
    users = slack_team.users(access_token)
    slack_users = users.map{|user| {email: user['profile']['email'], id: user['id'], image: user['profile']['image_72'] , is_admin: user['profile']['is_admin'], slack_team_id: user['team_id'], is_employee: !!Employee.find_by(email:user['profile']['email'] )}}
    render json: {slack: slack_team, slack_token: access_token, slack_users: slack_users, channels: channels}
  end

  def users
    slack_team = session_user.slack_team
    users = slack_team.users(session_user.access_token)
    users = slack_team.users(session_user['access_token'])
    slack_users = users.map{|user| {email: user['profile']['email'], id: user['id'], image: user['profile']['image_72'] , is_admin: user['profile']['is_admin'], slack_team_id: user['team_id'], is_employee: !!Employee.find_by(email:user['profile']['email'] )}}
    channels = slack_team.fetch_channels(session_user['access_token'])['channels'].map{|channel| {name: channel['name'], id: channel['id'], is_private: channel['is_private']}}
    render json: {slack: slack_team, slack_users: slack_users, channels: channels}
  end

 
end
