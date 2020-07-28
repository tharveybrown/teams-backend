
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
  
  def index
    slack_team = session_user.slack_team
    # channels = slack_team.fetch_channels(slack_team.bot_token)
    channels = slack_team.channels
    if channels 
      render json: {channels: channels}
    else
      render json: {errors: ["Unable to find channels"]}, status: 422
    end
  end

  def personality
    # slack_team = session_user.slack_team
    channel = Channel.find(params[:id])
    
    # channel = slack_team.channels.find{|c| c['name'] =='sea-sf-se-042020'}
    latest_messages = channel.fetch_messages
    
    if !latest_messages[0]['text']
      return render json: latest_messages, status: 422
    end

    
    message_content = latest_messages.map{|m| {"content": m.text, "contenttype": "text/plain", "created": Time.new(m.ts).to_i, "id": m.slack_id,  "language": "en"}}
    content = {"contentItems": message_content}
    watson_controller = WatsonController.new
    analysis = watson_controller.analyze(content)
    if !analysis.kind_of?(String)
    
      personalities = channel.build_personality(analysis[:personality])
      personalities.save
      render json: channel.personality
    else
      render json: analysis, status: 422
    end
    # render json: {channel.id: analysis}
  end


  
  
 
end
