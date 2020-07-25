class AddTimeStampToMessages < ActiveRecord::Migration[6.0]
  def change
    remove_column :messages, :time_stamp
    
  end
end
