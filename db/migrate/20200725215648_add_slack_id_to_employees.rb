class AddSlackIdToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :slack_id, :string
  end
end
