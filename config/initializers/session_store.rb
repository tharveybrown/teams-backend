if Rails.env === 'production' 
  Rails.application.config.session_store :cookie_store, key: '_teams-backend', domain: 'your-frontend-domain'
else
  Rails.application.config.session_store :cookie_store, key: '_teams-backend' 
end