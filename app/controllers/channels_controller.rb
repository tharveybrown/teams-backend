
class ChannelsController < ApplicationController
  

  def top_channel_messages
    slack_team = session_user.slack_team
    top_channels = slack_team.channels.order('num_members DESC').limit(10)
    # byebug
    top_channel_messages = top_channels.map{|channel| {channel['id'] => channel, "messages"=> channel.fetch_messages}}
    # messages = top_channels[0].fetch_messages()
    test_channel = slack_team.channels.find{|c| c['name'] =='sea-sf-se-042020'}
    #  UNCOMMENT BEFORE DEPLOYMENT
    # render json: {top_channels: top_channels}
    render json: {top_channels: [test_channel, top_channels].flatten}
    
  end

  def eligible_for_personality
    
  end

  def personality
    slack_team = session_user.slack_team
    # channel = Channel.find(params[:id])
    test_channel = slack_team.channels.find{|c| c['name'] =='sea-sf-se-042020'}
    # byebug
    latest_messages = test_channel.fetch_messages
    message_content = latest_messages.map{|m| {"content": m.text, "contenttype": "text/plain", "created": Time.new(m.ts).to_i, "id": m.slack_id,  "language": "en"}}

    content = {"contentItems": message_content}
    watson_controller = WatsonController.new
    analysis = watson_controller.analyze(content)
    # render json: {channel.id: analysis}
  end


  
  
 
end
