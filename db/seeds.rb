# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AnalysisMetadatum.destroy_all
api_v1_metadata = AnalysisMetadatum.create()
api_v1_metadata.personalities_description = {
  "Altruism / Altruistic": "Find that helping others is genuinely rewarding, that doing things for others is a form of self-fulfillment rather than self-sacrifice.",
  "Cooperation / Accommodating / Compliance": "Dislike confrontation. They are perfectly willing to compromise or to deny their own needs to get along with others.",
  "Modesty / Modest": "Are unassuming, rather self-effacing, and humble. However, they do not necessarily lack self-confidence or self-esteem.",
  "Morality / Uncompromising / Sincerity": "See no need for pretense or manipulation when dealing with others and are therefore candid, frank, and genuine.",
  "Sympathy / Empathetic": "Are tender-hearted and compassionate.",
  "Trust / Trusting of others": "Assume that most people are fundamentally fair, honest, and have good intentions. They take people at face value and are willing to forgive and forget.",
  "Achievement striving / Driven": "Try hard to achieve excellence. Their drive to be recognized as successful keeps them on track as they work hard to accomplish their goals.",
  "Cautiousness / Deliberate / Deliberateness": "Are disposed to think through possibilities carefully before acting.",
  "Dutifulness / Dutiful / Sense of responsibility": "Have a strong sense of duty and obligation.",
  "Orderliness / Organized": "Are well-organized, tidy, and neat.",
  "Self-discipline / Persistent": "Have the self-discipline, or 'will-power,' to persist at difficult or unpleasant tasks until they are completed.",
  "Self-efficacy / Self-assured / Sense of competence": "Are confident in their ability to accomplish things.",
  "Activity level / Energetic": "Lead fast-paced and busy lives. They do things and move about quickly, energetically, and vigorously, and they are involved in many activities.",
  "Assertiveness / Assertive": "Like to take charge and direct the activities of others. They tend to be leaders in groups.",
  "Cheerfulness / Cheerful / Positive emotions": "Experience a range of positive feelings, including happiness, enthusiasm, optimism, and joy.",
  "Excitement-seeking": "Are easily bored without high levels of stimulation.",
  "Friendliness / Outgoing / Warmth": "Genuinely like other people and openly demonstrate positive feelings toward others.",
  "Gregariousness / Sociable": "Find the company of others pleasantly stimulating and rewarding. They enjoy the excitement of crowds.",
  "Anger / Fiery": "Have a tendency to feel angry.",
  "Anxiety / Prone to worry": "Often feel like something unpleasant, threatening, or dangerous is about to happen. The 'fight-or-flight' system of their brains is too easily and too often engaged.",
  "Depression / Melancholy / Moodiness": "Tend to react more readily to life's ups and downs.",
  "Immoderation / Self-indulgence": "Feel strong cravings and urges that they have difficulty resisting, even though they know that they are likely to regret them later. They tend to be oriented toward short-term pleasures and rewards rather than long-term consequences.",
  "Self-consciousness": "Are sensitive about what others think of them. Their concerns about rejection and ridicule cause them to feel shy and uncomfortable around others; they are easily embarrassed.",
  "Vulnerability / Susceptible to stress / Sensitivity to stress": "Have difficulty coping with stress. They experience panic, confusion, and helplessness when under pressure or when facing emergency situations.",
  "Adventurousness / Willingness to experiment": "Are eager to try new activities and experience different things. They find familiarity and routine boring.",
  "Artistic interests": "Love beauty, both in art and in nature. They become easily involved and absorbed in artistic and natural events. With intellect, this facet is one of the two most important, central aspects of this characteristic.",
  "Emotionality / Emotionally aware / Depth of emotions": "Have good access to and awareness of their own feelings.",
  "Imagination": "View the real world as often too plain and ordinary. They use fantasy not as an escape but as a way of creating for themselves a richer and more interesting inner-world.",
  "Intellect / Intellectual curiosity": "Are intellectually curious and tend to think in symbols and abstractions. With artistic interests, this facet is one of the two most important, central aspects of this characteristic.",
  "Liberalism / Authority challenging / Tolerance for diversity": "Have a readiness to challenge authority, convention, and traditional values."
}