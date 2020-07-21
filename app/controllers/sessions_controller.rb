require 'net/http'
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :create, :begin_auth]

   # Note that we pass the `client_id`, `scope` and "redirect_uri" parameters specific to our application's configs.


  # If a user tries to access the index page, redirect them to the auth start page
  

  # OAuth Step 1: Show the "Add to Slack" button, which links to Slack's auth request page.
  # This page shows the user what our app would like to access and what bot user we'd like to create for their team.
  


  def create
    temp_code = request.query_parameters[:code]
    uri = URI('https://slack.com/api/oauth.v2.access')
    params = { :client_id => ENV['SLACK_CLIENT_ID'], :client_secret => ENV['SLACK_CLIENT_SECRET'], code: temp_code, redirect_uri: "http://localhost:3000/dashboard" }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    # @employee = Employee.find_or_create_by(full_name: auth_hash.info.name, member_id: auth_hash.info.user_id)
    response = JSON.parse(res.body)
    access_token = response['access_token']

    slack_team = SlackTeam.find_or_create_by(slack_id: response['team']['id'], name: response['team']['name'], organization_id: session_user.organization.id)
    slack_team.fetch_channels(access_token)
    render json: {slack: slack_team, slack_token: access_token}
    # redirect_back fallback_location: 'http://localhost:3000', allow_other_host: true #, { response }
  end

 
end
