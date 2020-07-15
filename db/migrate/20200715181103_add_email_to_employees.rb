class AddEmailToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :email, :string
  end
end
