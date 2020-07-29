class AddTsToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :ts, :datetime
  end
end
