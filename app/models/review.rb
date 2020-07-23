class Review < ApplicationRecord
  belongs_to :reviewer_employee, class_name: "Employee", foreign_key: :reviewer_id
  belongs_to :reviewed_employee, class_name: "Employee", foreign_key: :reviewed_id
end
