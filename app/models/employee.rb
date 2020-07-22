class Employee < ApplicationRecord
  has_secure_password
  has_many :subordinates, class_name: "Employee",
  foreign_key: "manager_id"

  belongs_to :manager, class_name: "Employee", optional: true
  belongs_to :organization, optional: true
  has_many :reviews
  has_and_belongs_to_many :skills
  has_one :slack_team, through: :organization
  accepts_nested_attributes_for :skills
  validates :email, uniqueness: true, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  
end
