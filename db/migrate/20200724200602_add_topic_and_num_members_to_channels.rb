class AddTopicAndNumMembersToChannels < ActiveRecord::Migration[6.0]
  def change
    add_column :channels, :topic, :string
    add_column :channels, :num_members, :integer
  end
end
