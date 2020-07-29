class Message < ApplicationRecord
  belongs_to :channel
  belongs_to :employee, optional: true
  
  
  
end