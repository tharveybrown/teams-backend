class PersonalitiesController < ApplicationController

  # def personality
  #   # byebug
  #   # slack_team = session_user.slack_team
  #   channel=Channel.find(params[:id])
  #   # channel = Channel.find(params[:id])
  #   # channel = slack_team.channels.find{|c| c['name'] =='sea-sf-se-042020'}
    
  #   @personality = Personality.find_by(channel_id: channel.id)
  #   if @personality
  #     render json: @personality
  #   else
  #     redirect_to your_controller_action_url and return
  #   end
  # end
end