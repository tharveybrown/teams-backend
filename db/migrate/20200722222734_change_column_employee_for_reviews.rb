class ChangeColumnEmployeeForReviews < ActiveRecord::Migration[6.0]
  def change

    remove_column :reviews, :employee_id
  end
end
