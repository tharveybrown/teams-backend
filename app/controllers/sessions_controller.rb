require 'net/http'
class SessionsController < ApplicationController
  def create
    temp_code = request.query_parameters[:code]
    uri = URI('https://slack.com/api/oauth.v2.access')
    params = { :client_id => ENV['SLACK_CLIENT_ID'], :client_secret => ENV['SLACK_CLIENT_SECRET'], code: temp_code }
    uri.query = URI.encode_www_form(params)
    
    res = Net::HTTP.get_response(uri)
    # @employee = Employee.find_or_create_by(full_name: auth_hash.info.name, member_id: auth_hash.info.user_id)
    
    response = JSON.parse(res.body)
    # byebug
    # render json: response
    redirect_back fallback_location: 'http://localhost:3000', allow_other_host: true #, { response }
  end

 
end
