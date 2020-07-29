class AnalysisMetadataController < ApplicationController

  def personalities
    
    all_metadata = AnalysisMetadatum.first
    @analysis_metadata = all_metadata.slice(
      "personalities_description",
      "openness",
      "adventurousness",
      "artistic_interests",
      "emotionality",
      "imagination",
      "intellect",
      "authority_challenging",
      "conscientiousness",
      "achievement_striving",
      "cautiousness",
      "dutifulness",
      "orderliness",
      "self_discipline",
      "self_efficacy",
      "extraversion",
      "activity_level",
      "assertiveness",
      "cheerfulness",
      "excitement_seeking",
      "outgoing",
      "gregariousness",
      "agreeableness",
      "altruism",
      "cooperation",
      "modesty",
      "uncompromising",
      "sympathy",
      "trust",
      "emotional_range",
      "fiery",
      "prone_to_worry",
      "melancholy",
      "immoderation",
      "self_consciousness",
      "susceptible_to_stress"
    )
    render json: @analysis_metadata
  end

  
end