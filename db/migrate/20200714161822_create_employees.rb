class CreateEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :job_type
      t.string :title
      t.belongs_to :organization, null: true, foreign_key: true
      t.references :manager, foreign_key: { to_table: :employees }

      t.timestamps
    end
  end
end
