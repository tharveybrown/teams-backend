class EmployeesSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :employees_skills, id: false do |t|
      t.belongs_to :employee
      t.belongs_to :skill
    end
  end
end
