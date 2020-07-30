class WatsonController < ApplicationController
  require "json"
  require "ibm_watson/authenticators"
  require "ibm_watson/personality_insights_v3"
  require "ibm_watson/natural_language_understanding_v1"
  include IBMWatson
  attr_accessor :url, :apikey

  def initialize
    @url = ENV['WATSON_URL']
    @apikey = ENV['WATSON_API_KEY']
    @language_apikey = ENV['WATSON_LANGUAGE_API_KEY']
    @language_url = ENV['WATSON_LANGUAGE_URL']
  end

  def get_data(input)
    authenticator = Authenticators::IamAuthenticator.new(
      apikey: @apikey
    )
    personality_insights = PersonalityInsightsV3.new(
      version: "2017-10-13",
      authenticator: authenticator
    )
    personality_insights.service_url = @url
    profile = personality_insights.profile(
      content: input,
      content_type: "application/json",
      raw_scores: true,
      accept: "application/json",
      consumption_preferences: true
    )
    profile.result
  end

  def get_keywords(input)
    language_authenticator = Authenticators::IamAuthenticator.new(
      apikey: @language_apikey
    )
    natural_language_understanding = NaturalLanguageUnderstandingV1.new(
      version: "2019-07-12",
      authenticator: language_authenticator
    )
    natural_language_understanding.service_url = @language_url
    
    keywords = natural_language_understanding.analyze(text: input, features: {keywords: {sentiment: true, emotion: true, limit: 10}})
    entities = natural_language_understanding.analyze(text: input, features: {entities: {sentiment: true, emotion: true, limit: 10}})
    {'entities': entities.result['entities'], 'keywords': keywords.result['keywords']}
    # entities.result
  end



 

  def to_symbol_helper(key)
    key.gsub(" ", "_").gsub("-", "_").gsub("&", "_and_").downcase.truncate(60).to_sym
  end

  def percentile_conversion_helper(value)
    (value * 100).to_i
  end

  def parse_personality(raw_personality)
    result = {}

    raw_personality.each do |trait|
      trait_name = self.to_symbol_helper(trait['name'])
      trait_percentile = self.percentile_conversion_helper(trait['percentile'])

      result[trait_name] = trait_percentile

      trait['children'].each do |category|
        category_name = self.to_symbol_helper(category['name'])
        category_percentile = self.percentile_conversion_helper(category['percentile'])

        result[category_name] = category_percentile
      end
    end

    result
  end

  def parse_needs(raw_needs)
    result = {}

    raw_needs.each do |need|
      need_name = self.to_symbol_helper(need['name'])
      need_percentile = self.percentile_conversion_helper(need['percentile'])
      result[need_name] = need_percentile
    end

    result
  end

  def parse_values(raw_values)
    result = {}

    raw_values.each do |value|
      value_name = self.to_symbol_helper(value['name'])
      value_percentile = self.percentile_conversion_helper(value['percentile'])

      result[value_name] = value_percentile
    end

    result
  end

  def parse_consumption_preferences(raw_preferences)
    result = {}

    raw_preferences.each do |category|
      category['consumption_preferences'].each do |pref|
        pref_name = self.to_symbol_helper(pref['name'])
        pref_score = self.percentile_conversion_helper(pref['score']) # will be 0, 50, or 100

        result[pref_name] = pref_score
      end
    end

    result
  end

  def analyze(input)
    result = {}
    raw_data = self.get_data(input)

    if raw_data['code'] == 400
      return raw_data['error']
    else
      result[:word_count] = {
        word_count: raw_data['word_count'].to_i,
        word_count_message: raw_data['word_count_message']
      }
      result[:personality] = self.parse_personality(raw_data['personality'])
      result[:need] = self.parse_needs(raw_data['needs'])
      result[:value] = self.parse_values(raw_data['values'])
      result[:consumption_preference] = self.parse_consumption_preferences(raw_data['consumption_preferences'])

      return result
    end
  end

  def analyze_keywords(input)
    result = {}
    raw_data = self.get_keywords(input)
    
    if raw_data['code'] == 400
      return raw_data['error']
    else
      
      keywords = raw_data[:keywords].map{|entity| {keyword: entity['text'], sentiment: {score: (entity['sentiment']['score'] * 100).to_i, label: entity['sentiment']['label']}, emotions: entity['emotion'].map{|k, e| {k => e*100.to_i}}}}
      entities = raw_data[:entities].map{|entity| {entity: entity['text'], sentiment: {score: (entity['sentiment']['score'] * 100).to_i, label: entity['sentiment']['label']}, emotions: entity['emotion'].map{|k, e| {k => e*100.to_i}}}}
      result[:keywords] = keywords
      result[:entities] = entities
      return result
    end
  end

end