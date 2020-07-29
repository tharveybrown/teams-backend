
class ChannelsController < ApplicationController
  

  def top_channels
    slack_team = session_user.slack_team
    # channels = slack_team.fetch_channels(slack_team.bot_token)
    top_channels = slack_team.channels.order('num_members DESC').limit(10)
    # byebug
    top_channel_messages = top_channels.map{|channel| {"channel" => channel, "messages"=> channel.messages.first ? true : false}}
    sorted_channels = top_channel_messages.sort_by{|m| m['messages'] ? 0 : 1}
    render json: {top_channels: sorted_channels}
    
  end

  def channel_keywords
    channel = Channel.find(params[:id])
    # messages = channel.fetch_messages
    messages = channel.messages
    text = messages.map{|m| m['text']}.join
    watson_controller = WatsonController.new
    analysis = watson_controller.analyze_keywords(text)
    if !!analysis[:keywords]
      render json: analysis[:keywords]
    else
      render json: analysis, status: 422
    end

  end

  def eligible_for_personality
    
  end
  
  def index
    slack_team = session_user.slack_team
    channels = slack_team.fetch_channels(slack_team.bot_token)
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
    latest_messages = channel.fetch_latest_messages
    
    if !latest_messages[0]['text']
      return render json: latest_messages, status: 422
    end

    
    message_content = channel.messages.map{|m| {"content": m.text, "contenttype": "text/plain", "created": Time.new(m.ts).to_i, "id": m.slack_id,  "language": "en"}}
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
