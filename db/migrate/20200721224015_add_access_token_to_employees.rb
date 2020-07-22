class AddAccessTokenToEmployees < ActiveRecord::Migration[6.0]
  def change
    add_column :employees, :access_token, :string
  end
end
