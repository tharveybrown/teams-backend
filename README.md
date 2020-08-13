# Webbed backend

HR tech application with built-in slack bot that integrates with IBM Watson's Personality Insights and Natural Language Understanding. The frontend for this application is built with react and can be found [here](https://github.com/tharveybrown/webbed).

This application requires a slack client id, which can be obtained after [registering a new bot](https://api.slack.com/apps). Once registered, set the following redirect uris:

- http://localhost:3001/auth/callback
- http://localhost:3000/dashboard

This app uses the [Figaro gem](https://github.com/laserlemon/figaro) to manage environment variables. After running `bundle install`, run `bundle exec figaro install` to generate an application.yml file. Sample configuration below:

```.yml
SLACK_CLIENT_ID: <slack_client_id>
SLACK_CLIENT_SECRET: <slack_bot_secret>
SLACK_BOT_ACCESS_TOKEN: <slack_bot_token>
FRONTEND_URL: "http://localhost:3000/dashboard"
WATSON_URL: <watson_personality_insights_url>
WATSON_API_KEY: <watson_persaonlity_insights_api_key>
WATSON_LANGUAGE_URL: <watson_language_url>
WATSON_LANGUAGE_API_KEY: <watson_language_api_key>
```

To start the application, run `npm start` from the frontend repository and `rails s` from the this repository.
