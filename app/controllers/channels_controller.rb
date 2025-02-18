
class ChannelsController < ApplicationController
  

  def top_channels
    slack_team = session_user.slack_team
    
    top_channels = slack_team.channels.order('num_members DESC').limit(10)
    top_channel_messages = top_channels.map{|channel| {"channel" => channel, "messages"=> channel.fetch_latest_messages.length > 2 ? true : false}}
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
      render json: {keywords: analysis[:keywords], entities: analysis[:entities]}
    else
      render json: analysis, status: 422
    end

  end

  def eligible_for_personality
    
  end
  
  def index
    slack_team = session_user.slack_team
    
    channels = slack_team.channels
    if channels 
      render json: {channels: channels}
    else
      render json: {errors: ["Unable to find channels"]}, status: 422
    end
  end

  def fetch_update
    slack_team = session_user.slack_team
    channels = slack_team.fetch_channels(slack_team.bot_token)
    if channels 
      render json: {channels: channels}
    else
      render json: {errors: ["Unable to find channels"]}, status: 422
    end
  
  end

  def personality
    channel = Channel.find(params[:id])
    
    latest_messages = channel.fetch_latest_messages
    
    if latest_messages.length == 2
      return render json: {errors: ["You must /invite @webbed to this channel first"]}, status: 422
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
