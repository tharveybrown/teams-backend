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
    response = JSON.parse(res.body)
    if response['access_token']
      bot_access_token = response['access_token']
      access_token = response['authed_user']['access_token']
      slack_team = SlackTeam.find_or_create_by(slack_id: response['team']['id'], name: response['team']['name'], organization_id: session_user.organization.id)
      slack_team.bot_token = bot_access_token
      slack_team.save
      @employee = Employee.find(session_user[:id])
      @employee.access_token = access_token
      @employee.organization.slack_team = slack_team
      @employee.slack_id = response['authed_user']['id']
      @employee.save   
      channels = slack_team.fetch_channels(access_token)
      users = slack_team.users(bot_access_token)
      slack_users = users.map{|user| {email: user['profile']['email'], id: user['id'], image: user['profile']['image_72'] , is_admin: user['profile']['is_admin'], slack_team_id: user['team_id'], is_employee: !!Employee.find_by(email:user['profile']['email'] )}}
      render json: {slack: slack_team, slack_token: access_token, slack_users: slack_users, channels: channels}
    else
      render json: {errors: ["error finding slack team"]}
    end
  end

  def update_channels
    slack_team = session_user.slack_team
    channels = slack_team.fetch_channels(slack_team.bot_token)
  
  end

  def users
    slack_team = session_user.slack_team
    users = slack_team.users(slack_team.bot_token)
    slack_users = users.map{|user| {email: user['profile']['email'], id: user['id'], image: user['profile']['image_72'] , is_admin: user['profile']['is_admin'], slack_team_id: user['team_id'], is_employee: !!Employee.find_by(email:user['profile']['email'] )}}
    # channels = slack_team.channels
    # render json: {slack: slack_team, slack_users: slack_users, channels: channels}
    render json: {slack: slack_team, slack_users: slack_users}
  end


 
end
