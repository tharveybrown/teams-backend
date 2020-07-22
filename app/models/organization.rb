class Organization < ApplicationRecord
  has_many :employees
  has_one :slack_team
end
