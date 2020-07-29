class ChangeTsForMessages < ActiveRecord::Migration[6.0]
  def change
    change_column :messages, :ts, :string
  end
end
